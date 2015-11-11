Textbook::Application.routes.draw do
  devise_for :users

  root to: 'home#show'

  get 'table-of-contents', to: redirect('courses')

  resources :sections, except: [:show] do
    resources :lessons, only: [:index]
  end
  resources :lessons
  resources :courses
  get '/:id', to: 'sections#show', as: :section_show
  get '/:section_id/:id', to: 'lessons#show', as: :section_lesson_show
end
