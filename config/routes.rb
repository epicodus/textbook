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
    resources :sections, only: [:index, :new, :create]
    resources :sections, only: [:show, :edit, :update, :destroy], path: '/' do
      resources :lessons, only: [:index]
    end
  end

  get '/:course_id/:section_id/:id', to: 'lessons#show', as: :course_section_lesson_show
end
