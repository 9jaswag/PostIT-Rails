Rails.application.routes.draw do
  get 'index/index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  scope "/users", as: "users" do
    get "/search/:username" => "users#search", as: "search"
  end

  resources :users
  resources :groups do
    resources :messages
  end

  root 'index#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
