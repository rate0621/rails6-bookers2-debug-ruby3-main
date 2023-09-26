Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root :to =>"homes#top"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]
  resources :users, only: [:index,:show,:edit,:update]
  get "home/about"=>"homes#about"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :favorites, only: [:create, :destroy]

  resources :books do
    resources :book_comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  resources :users do
    member do
      get :followers
      get :following
    end
  end

  get 'search', to: 'searches#search'

  resources :messages, only: [:new, :create, :index] do
    collection do
      get 'select_recipient'
    end
  end
end
