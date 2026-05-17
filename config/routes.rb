Rails.application.routes.draw do
  resources :places
  resources :events do
    resources :tickets, only: %i[ new create ]
  end
  get "admin", to: "admin/dashboard#show", as: :admin_dashboard
  get "harita", to: "maps#show", as: :campus_map
  get "bildirimler", to: "notifications#index", as: :notifications
  get "hava-durumu", to: "weather#show", as: :weather

  get "kayit-ol", to: "registrations#new", as: :signup
  post "kayit-ol", to: "registrations#create"
  get "giris", to: "sessions#new", as: :login
  post "giris", to: "sessions#create"
  delete "cikis", to: "sessions#destroy", as: :logout

  get "up" => "rails/health#show", as: :rails_health_check

  root "places#index"
end
