module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def show
      @total_users = User.count
      @total_places = Place.count
      @total_events = Event.count
      @total_tickets = Ticket.count
      @ticket_revenue = Ticket.sum(:total_price)
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_events = Event.order(starts_at: :desc).limit(5)
      @recent_places = Place.order(created_at: :desc).limit(5)
    end
  end
end
