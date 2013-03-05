Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  resources :chapters, :except => [:show]
  resources :sections, :except => [:index, :show]
  resources :lessons
end
