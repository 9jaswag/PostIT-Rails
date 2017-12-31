Rails.application.routes.draw do
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
  end

  resources :users
  resources :groups do
    resources :messages
  end

  root 'index#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
