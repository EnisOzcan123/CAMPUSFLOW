class NotificationsController < ApplicationController
  def index
    @forecast = WeatherForecast.new
    @current_weather = @forecast.current
    @daily_weather = @forecast.daily
    @events = Event.upcoming.includes(:place).limit(10)
    @event_weather = @events.first(4).map do |event|
      forecast = @forecast.event_forecast(event)

      {
        event: event,
        forecast: forecast,
        risky: @forecast.bad_weather?(forecast)
      }
    end
    @notifications = build_notifications
  end

  private

    def build_notifications
      @events.filter_map do |event|
        event_weather = @forecast.event_forecast(event)
        weather_bad = @forecast.bad_weather?(event_weather)
        starts_soon = event.starts_at <= 24.hours.from_now
        outdoor_event = outdoor_event?(event)

        next unless starts_soon || weather_bad

        {
          event: event,
          weather: event_weather,
          kind: notification_kind(weather_bad, outdoor_event),
          title: notification_title(event, weather_bad, outdoor_event),
          message: notification_message(event, event_weather, weather_bad, outdoor_event)
        }
      end
    end

    def outdoor_event?(event)
      text = "#{event.location} #{event.place&.category} #{event.place&.location_label}".downcase
      text.include?("bahçe") || text.include?("açık") || text.include?("sahne") || text.include?("stadyum")
    end

    def notification_kind(weather_bad, outdoor_event)
      return :danger if weather_bad && outdoor_event
      return :warning if weather_bad

      :info
    end

    def notification_title(event, weather_bad, outdoor_event)
      return "#{event.title} hava nedeniyle iptal edildi" if weather_bad && outdoor_event
      return "#{event.title} için hava uyarısı var" if weather_bad

      "#{event.title} yaklaşıyor"
    end

    def notification_message(event, event_weather, weather_bad, outdoor_event)
      if weather_bad && outdoor_event
        "Sebep: etkinlik açık alanda ve hava tahmini olumsuz. Tahmin: #{event_weather[:summary]}, yağış olasılığı %#{event_weather[:precipitation_probability]}, rüzgar #{event_weather[:wind_speed]} km/sa."
      elsif weather_bad
        "Etkinlik günü hava olumsuz görünüyor: #{event_weather[:summary]}, yağış olasılığı %#{event_weather[:precipitation_probability]}."
      else
        "#{event.starts_at.strftime('%d.%m.%Y %H:%M')} tarihinde #{event.location} konumunda başlayacak."
      end
    end
  end
