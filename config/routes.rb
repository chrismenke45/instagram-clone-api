Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :posts, only: [:index, :show, :create, :destroy] do
    resources :comments, only: [:index, :create, :destory]
  end
  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"
end
