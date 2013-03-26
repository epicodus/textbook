Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  resources :chapters do
    collection do
      put :update_multiple
    end
  end

  resources :sections, :except => [:index]
  resources :lessons
end
