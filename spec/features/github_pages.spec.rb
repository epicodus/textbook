require 'spec_helper'

describe GithubCallback do
  feature "Github repo push webhook comes in", :js do
    before { allow(Github).to receive(:update_lessons_from_github) }

    scenario "and triggers lesson update method" do
      repo = 'testing'
      files = ['README.md']
      fake_github_webhook = FakeWebhook.new(
        fixture: "fake_github_webhook.json",
        path: "/github_callbacks",
        host: Capybara.current_session.server.host,
        port: Capybara.current_session.server.port
      )
      expect(Github).to receive(:update_lessons_from_github).with(repo, files)
      fake_github_webhook.send
    end
  end
end
