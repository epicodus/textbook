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
      expect(Github).to receive(:update_lessons).with({ repo: 'testing', modified: ['README.md'], removed: [] })
      fake_github_webhook.send
    end

    scenario "and triggers section update" do
      fake_github_webhook = FakeWebhook.new(
        fixture: "fake_github_webhook_update_section.json",
        path: "/github_callbacks",
        host: Capybara.current_session.server.host,
        port: Capybara.current_session.server.port
      )
      expect(GithubReader).to receive(:update_sections).with({ repo: 'testing', directories: ['example'] })
      fake_github_webhook.send
    end
  end
end
