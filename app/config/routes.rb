Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "status#index"
  get "/health", to: "status#health"
  get "/ready", to: "status#ready"
end
