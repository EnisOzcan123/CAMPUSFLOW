require "json"
require "net/http"

class WeatherForecast
  CAMPUS_LATITUDE = 39.904583
  CAMPUS_LONGITUDE = 41.255474
  TIMEZONE = "Europe/Istanbul"

  def initialize(latitude: CAMPUS_LATITUDE, longitude: CAMPUS_LONGITUDE)
    @latitude = latitude
    @longitude = longitude
  end

  def current
    payload.dig("current") || {}
  end

  def daily
    daily_data = payload["daily"] || {}
    times = daily_data["time"] || []

    times.map.with_index do |date, index|
      {
        date: date,
        weather_code: daily_data.dig("weather_code", index),
        max_temperature: daily_data.dig("temperature_2m_max", index),
        min_temperature: daily_data.dig("temperature_2m_min", index),
        precipitation_probability: daily_data.dig("precipitation_probability_max", index),
        wind_speed: daily_data.dig("wind_speed_10m_max", index),
        summary: weather_summary(daily_data.dig("weather_code", index))
      }
    end
  end

  def event_forecast(event)
    hourly_data = payload["hourly"] || {}
    times = hourly_data["time"] || []
    return nil if times.empty?

    target_time = event.starts_at.in_time_zone(TIMEZONE)
    nearest_index = times.each_index.min_by do |index|
      (Time.zone.parse(times[index]) - target_time).abs
    end

    {
      time: times[nearest_index],
      temperature: hourly_data.dig("temperature_2m", nearest_index),
      precipitation: hourly_data.dig("precipitation", nearest_index),
      precipitation_probability: hourly_data.dig("precipitation_probability", nearest_index),
      wind_speed: hourly_data.dig("wind_speed_10m", nearest_index),
      weather_code: hourly_data.dig("weather_code", nearest_index),
      summary: weather_summary(hourly_data.dig("weather_code", nearest_index))
    }
  end

  def weather_summary(code)
    case code.to_i
    when 0 then "Açık"
    when 1, 2 then "Parçalı bulutlu"
    when 3 then "Bulutlu"
    when 45, 48 then "Sisli"
    when 51, 53, 55 then "Çiseleme"
    when 56, 57 then "Dondurucu çiseleme"
    when 61, 63, 65 then "Yağmurlu"
    when 66, 67 then "Dondurucu yağmur"
    when 71, 73, 75, 77 then "Kar yağışlı"
    when 80, 81, 82 then "Sağanak yağışlı"
    when 85, 86 then "Kar sağanaklı"
    when 95, 96, 99 then "Gök gürültülü"
    else "Bilinmiyor"
    end
  end

  def weather_icon(code)
    case code.to_i
    when 0 then "bi-sun-fill"
    when 1, 2 then "bi-cloud-sun-fill"
    when 3 then "bi-cloud-fill"
    when 45, 48 then "bi-cloud-fog2-fill"
    when 51, 53, 55, 56, 57 then "bi-cloud-drizzle-fill"
    when 61, 63, 65, 66, 67, 80, 81, 82 then "bi-cloud-rain-heavy-fill"
    when 71, 73, 75, 77, 85, 86 then "bi-cloud-snow-fill"
    when 95, 96, 99 then "bi-cloud-lightning-rain-fill"
    else "bi-cloud-fill"
    end
  end

  def weather_tone(code)
    case code.to_i
    when 0, 1, 2 then "sunny"
    when 3, 45, 48 then "cloudy"
    when 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82, 95, 96, 99 then "rainy"
    when 71, 73, 75, 77, 85, 86 then "snowy"
    else "cloudy"
    end
  end

  def bad_weather?(forecast)
    return false if forecast.blank?

    code = forecast[:weather_code].to_i
    precipitation_probability = forecast[:precipitation_probability].to_i
    precipitation = forecast[:precipitation].to_f
    wind_speed = forecast[:wind_speed].to_f

    code.in?([61, 63, 65, 66, 67, 71, 73, 75, 77, 80, 81, 82, 85, 86, 95, 96, 99]) ||
      precipitation_probability >= 60 ||
      precipitation >= 2.0 ||
      wind_speed >= 40
  end

  private

    attr_reader :latitude, :longitude

    def payload
      @payload ||= begin
        uri = URI("https://api.open-meteo.com/v1/forecast")
        uri.query = URI.encode_www_form(
          latitude: latitude,
          longitude: longitude,
          current: "temperature_2m,precipitation,weather_code,wind_speed_10m",
          hourly: "temperature_2m,precipitation_probability,precipitation,weather_code,wind_speed_10m",
          daily: "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,wind_speed_10m_max",
          forecast_days: 10,
          timezone: TIMEZONE
        )

        response = Net::HTTP.get_response(uri)
        return {} unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      rescue StandardError
        {}
      end
    end
end
