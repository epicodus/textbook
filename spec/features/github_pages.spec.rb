require 'spec_helper'

describe GithubCallback do
  feature "Github repo push webhook comes in", :js do
    scenario "and triggers lesson update method" do
      fake_github_webhook = FakeWebhook.new(
        fixture: "fake_github_webhook.json",
        path: "/github_callbacks",
        host: Capybara.current_session.server.host,
        port: Capybara.current_session.server.port
      )
      expect_any_instance_of(GithubCallback).to receive(:update_lessons)
      fake_github_webhook.send
    end

    scenario "and triggers section update" do
      fake_github_webhook = FakeWebhook.new(
        fixture: "fake_github_webhook_update_section_layout.json",
        path: "/github_callbacks",
        host: Capybara.current_session.server.host,
        port: Capybara.current_session.server.port
      )
      expect_any_instance_of(GithubCallback).to receive(:update_sections)
      fake_github_webhook.send
    end
  end
end
