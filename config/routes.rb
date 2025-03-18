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

  # Devise
  devise_for :employees, path: "employees", controllers: {
    sessions: "employees/sessions",
    registrations: "employees/registrations",
    passwords: "employees/passwords"
  }, skip: [ :registrations ]

  # Rotas personalizadas para registrations - somente edit e destroy
  devise_scope :employee do
    get "employees/edit", to: "employees/registrations#edit", as: "edit_employee_registration"
    put "employees", to: "employees/registrations#update", as: "employee_registration"
    delete "employees", to: "employees/registrations#destroy"
    # Bloqueamos sign_up e new
    get "employees/sign_up", to: redirect("/company/register")
    post "employees", to: redirect("/company/register")
  end

  # Company Namespace
  namespace :company do
    # Dashboard
    get "dashboard", to: "dashboards#index", as: :dashboard

    # Login para área de empresas
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    # Registro de empresas (wizard)
    get "register", to: "registrations#new", as: :register
    post "register", to: "registrations#create"
    get "register/step_2", to: "registrations#step_2", as: :registrations_step_2
    patch "register/step_2", to: "registrations#save_step_2"
    get "register/step_3", to: "registrations#step_3", as: :registrations_step_3
    patch "register/step_3", to: "registrations#save_step_3"
    get "register/step_4", to: "registrations#step_4", as: :registrations_step_4
    patch "register/complete", to: "registrations#complete", as: :registrations_complete

    # CRUD de funcionários
    resources :employees

    # CRUD de times
    resources :teams

    # CRUD de escritórios
    resources :offices
  end

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
