Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :rooms, only: [:create, :show], param: :slug do
    resources :videos, only: [:create, :update]
  end
  
  # [AI Generated] Data: 21/10/2025
  # Descrição: Rota para /room/:id compatível com frontend Vue.js.
  # Gerado por: Cursor AI
  # AI_GENERATED_CODE_START
  get '/room/:id', to: 'rooms#show', as: :room_page
  # AI_GENERATED_CODE_END

  # [AI Generated] Data: 21/10/2025
  # Descrição: Monta ActionCable para WebSocket em /cable (antes do catch-all).
  # Gerado por: Cursor AI
  # AI_GENERATED_CODE_START
  mount ActionCable.server => '/cable'
  # AI_GENERATED_CODE_END

  # Defines the root path route ("/")
  # [AI Generated] Data: 21/10/2025
  # Descrição: Serve o frontend Vue.js na raiz.
  # Gerado por: Cursor AI
  # AI_GENERATED_CODE_START
  root "application#index"
  
  # Catch-all route para SPA (deve vir por último)
  get '*path', to: 'application#index'
  # AI_GENERATED_CODE_END
end
