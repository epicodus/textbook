Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  resources :chapters
  resources :sections
  resources :pages
end
