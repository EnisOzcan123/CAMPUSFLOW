class EventsController < ApplicationController
  before_action :require_admin, except: %i[ index show ]
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    @events = Event.upcoming
    @event_types = Event.distinct.order(:event_type).pluck(:event_type)

    if params[:event_type].present?
      @events = @events.where(event_type: params[:event_type])
    end

    if params[:query].present?
      query = "%#{params[:query]}%"
      @events = @events.where("title ILIKE ? OR description ILIKE ? OR location ILIKE ?", query, query, query)
    end
  end

  def show
    @forecast = WeatherForecast.new
    @event_weather = @forecast.event_forecast(@event)
    @weather_risky = @forecast.bad_weather?(@event_weather)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Etkinlik başarıyla oluşturuldu."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Etkinlik başarıyla güncellendi.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy!
    redirect_to events_path, notice: "Etkinlik başarıyla silindi.", status: :see_other
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :event_type, :description, :starts_at, :location, :place_id, :ticket_required, :ticket_price, :ticket_url)
    end
end
