Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  resources :chapters
  resources :sections, :except => [:index]
  resources :lessons
end
