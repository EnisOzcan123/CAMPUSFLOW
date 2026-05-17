class TicketsController < ApplicationController
  before_action :require_login
  before_action :set_event
  before_action :ensure_ticketed_event

  def new
    @ticket = @event.tickets.new(quantity: 1)
    load_weather
  end

  def create
    quantity = ticket_params[:quantity].to_i.clamp(1, 5)
    @ticket = @event.tickets.new(
      user: current_user,
      quantity: quantity,
      total_price: @event.ticket_price.to_d * quantity,
      status: "confirmed",
      card_holder_name: ticket_params[:card_holder_name],
      card_number: ticket_params[:card_number],
      expiry_month: ticket_params[:expiry_month],
      expiry_year: ticket_params[:expiry_year],
      cvv: ticket_params[:cvv],
      payer_iban: ticket_params[:payer_iban]
    )

    if @ticket.save
      redirect_to @event, notice: "Bilet başarıyla oluşturuldu. Toplam tutar: #{helpers.number_to_currency(@ticket.total_price, unit: '₺', format: '%n %u')}."
    else
      load_weather
      render :new, status: :unprocessable_content
    end
  end

  private

    def set_event
      @event = Event.find(params[:event_id])
    end

    def ensure_ticketed_event
      return if @event.ticket_required?

      redirect_to @event, alert: "Bu etkinlik için bilet gerekmiyor."
    end

    def load_weather
      @forecast = WeatherForecast.new
      @event_weather = @forecast.event_forecast(@event)
      @weather_risky = @forecast.bad_weather?(@event_weather)
    end

    def ticket_params
      params.fetch(:ticket, {}).permit(:quantity, :card_holder_name, :card_number, :expiry_month, :expiry_year, :cvv, :payer_iban)
    end
end
