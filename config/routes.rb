Textbook::Application.routes.draw do
  devise_for :users

  root to: 'home#show'

  get 'table-of-contents', to: redirect('courses')

  resources :lessons
  resources :courses, only: [:index, :new, :create] do
    put :update_multiple, on: :collection
  end
  resources :courses, only: [:edit, :update, :destroy], path: '/'
  resources :courses, only: [:show], path: '/' do
    resources :sections, only: [:index, :new, :create, :edit] do
      resource :export, only: [:show], to: 'course_section_export#show'
    end
    resources :sections, only: [:show, :update, :destroy], path: '/' do
      resources :lessons, only: [:index]
      resources :lessons, only: [:show], path: '/'
    end
  end
end
