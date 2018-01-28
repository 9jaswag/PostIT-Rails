Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'index/index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  scope "/users", as: "users" do
    get "/search/:username/:group_id" => "groups#search", as: "search"
  end

  scope "/groups", as: "groups" do
    post "/:group_id/user/:user_id" => "groups#add_member", as: "add_member"
    delete "/:group_id/user/:user_id" => "groups#remove_member", as: "remove_member"
    get "/:id/unread_count" => "groups#get_unread_count", as: "get_unread_count"
  end

  put "/message/:id/user/:user" => "messages#update", as: "update_readby"

  resources :users
  resources :groups do
    resources :messages
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update], as: "reset"

  root 'index#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
