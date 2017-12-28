Rails.application.routes.draw do
  get 'index/index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users
  resources :groups do
    # message do
    #   get :message
    # end
  end

  root 'index#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
