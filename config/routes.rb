Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "inspections", to: "inspections#index"
  get "calendar", to: "calendar#index"

  get "reports", to: "reports#index"
  get "reports/compliance", to: "reports#compliance"
  get "reports/defect_register", to: "reports#defect_register"

  get "settings", to: "settings#show"

  resources :defects do
    member do
      patch :advance
    end
  end

  resources :addresses do
    resources :buildings, shallow: true
    resources :schedules, shallow: true
    # path: "equipment" avoids colliding with the /assets pipeline mount used for compiled CSS/JS.
    resources :assets, path: "equipment", shallow: true

    resources :inspection_visits, only: [ :index, :new, :create, :show ] do
      resources :asset_inspection_records, only: [ :index ]
      resource :completion, only: [ :create ], controller: "inspection_visit_completions"
    end
  end

  resources :asset_inspection_records, only: [ :update ]
end
