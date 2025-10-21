Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :rooms, only: [:create, :show], param: :slug do
    resources :videos, only: [:create, :update]
  end
  
  get '/room/:id', to: 'rooms#show', as: :room_page

  mount ActionCable.server => '/cable'

  root "application#index"
  get '*path', to: 'application#index'
end
