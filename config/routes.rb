Rails.application.routes.draw do
  devise_for :users
  get "events/create"
  resources :games
  resources :pages
  resources :lessons do
    collection do
      get :student_index
    end
    member do
      get :student_show
      get :reorder
      patch :update_positions
    end
  end
  resources :events, only: [:create]
  resources :question_responses, only: [:create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "lessons#student_index"
end
