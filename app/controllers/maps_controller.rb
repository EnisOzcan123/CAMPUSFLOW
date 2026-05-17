class MapsController < ApplicationController
  def show
    @places = Place.where.not(latitude: nil, longitude: nil).order(:name)
    @events = Event.upcoming.includes(:place).select { |event| event.place&.latitude.present? && event.place&.longitude.present? }
    @selected_place = @places.find { |place| place.id == params[:place_id].to_i } if params[:place_id].present?
  end
end
