class GithubCallbacksController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    github_callback = GithubCallback.new(params)
    begin
      github_callback.update_all if github_callback.push_to_master?
    rescue GithubError => e
      HTTParty.post(ENV['ZAPIER_ERROR_REPORTING_WEBHOOK'], body: { error: e.message })
    end
    head :ok
  end
end
