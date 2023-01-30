Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :posts, only: [:index, :show, :create, :destroy] do
    resources :comments, only: [:index, :create, :destory]
    resources :likes, only: [:index, :create]
    delete "/likes", to: "likes#destroy"
  end
  resources :users, only: [:index, :create, :show, :update, :destroy] do
    resources :follows, only: [:index, :create]
    delete "/follows", to: "follows#destroy"
    resources :messages, only: [:index, :create]
    get "/messages/:sender_id", to: "messages#show"
  end
  post "auth/login", to: "authentications#login"
  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"
end
