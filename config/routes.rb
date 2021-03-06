Rails.application.routes.draw do
  devise_for :users
  resources :movies do
    member do
      post :favorite
      post :hate
    end

  resources :reviews
    end

  namespace :account do
    resources :movies
   resources :reviews
  end

root 'movies#index'
end
