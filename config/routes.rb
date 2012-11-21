Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  resources :chapters
  resources :sections
  resources :lessons
end
