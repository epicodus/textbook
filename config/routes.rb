Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  get 'table_of_contents' => 'chapters#index'

  resources :lessons
  resources :sections
  resources :chapters do
    collection do
      put :update_multiple
    end
  end
end
