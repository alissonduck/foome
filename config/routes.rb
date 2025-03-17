Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"

  get "terms", to: "pages#terms", as: :terms
  get "privacy", to: "pages#privacy", as: :privacy
  get "contact", to: "pages#contact", as: :contact

  # Rotas para States
  resources :states, only: [ :index, :show ] do
    get "by_abbreviation/:abbreviation", on: :collection, to: "states#by_abbreviation", as: :by_abbreviation
    resources :cities, only: [ :index ], controller: "cities"
  end

  # Rotas para Cities
  resources :cities, only: [ :index, :show ] do
    collection do
      get "search"
    end
  end
end
