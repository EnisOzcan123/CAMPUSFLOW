class WeatherController < ApplicationController
  def show
    redirect_to notifications_path
  end
end
