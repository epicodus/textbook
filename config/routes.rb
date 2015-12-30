Textbook::Application.routes.draw do
  devise_for :users

  root to: 'home#show'

  get 'table-of-contents', to: redirect('courses')

  resources :lessons
  resources :courses do
    resources :sections do
      resources :lessons, only: [:index]
    end
    put :update_multiple, on: :collection
  end

  get '/:course_id/:section_id/:id', to: 'lessons#show', as: :course_section_lesson_show
end
