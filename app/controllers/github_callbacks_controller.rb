class GithubCallbacksController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    github_callback = GithubCallback.new(params)
    begin
      if github_callback.push_to_main?
        github_callback.update_sections
        github_callback.update_lessons
      end
    rescue GithubError => e
      HTTParty.post(ENV['ZAPIER_ERROR_REPORTING_WEBHOOK'], body: { error: e.message })
    end
    head :ok
  end
end
