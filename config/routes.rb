Textbook::Application.routes.draw do
  require "resque_web"

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.author?
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end

  devise_for :users

  root to: 'home#show'

  get 'table-of-contents', to: redirect('courses')

  resources :tracks, only: [:index, :show]
  resources :lessons
  resources :courses, only: [:index, :new, :create] do
    put :update_multiple, on: :collection
  end
  resources :courses, only: [:edit, :update, :destroy], path: '/'
  resources :courses, only: [:show], path: '/' do
    resources :sections, only: [:index, :new, :create, :edit]
    resources :sections, only: [:show, :update, :destroy], path: '/' do
      resources :lessons, only: [:index]
      resources :lessons, only: [:show], path: '/'
    end
  end

  resources :github_callbacks, only: [:create]
end
