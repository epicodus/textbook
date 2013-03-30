Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  match 'table_of_contents' => 'chapters#index'

  resources :chapters do
    collection do
      put :update_multiple
    end
  end

  resources :sections, :except => [:index]
  resources :lessons
end
