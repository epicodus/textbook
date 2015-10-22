Textbook::Application.routes.draw do
  devise_for :users

  root :to => 'home#show'

  get 'table-of-contents' => 'chapters#index', :as => 'table_of_contents'
  get 'table_of_contents' => redirect('table-of-contents')

  resources :sections do
    resources :lessons, except: [:new, :create]
  end
  resources :lessons, only: [:new, :create]
  resources :chapters do
    collection do
      put :update_multiple, :path => ''
    end
  end
end
