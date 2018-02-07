class GithubCallbacksController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    github_callback = GithubCallback.new(params)
    github_callback.update_lessons if github_callback.push_to_master?
    head :ok
  end
end
