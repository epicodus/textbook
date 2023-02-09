# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'selenium/webdriver'
require 'simplecov'
# require 'coveralls'
require 'cancan/matchers'

# Coveralls.wear!('rails')

SimpleCov.start 'rails' do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end

  add_filter %w[version.rb initializer.rb]
end

# SimpleCov.formatter = Coveralls::SimpleCov::Formatter
# SimpleCov.formatters = [
#   SimpleCov::Formatter::HTMLFormatter,
#   Coveralls::SimpleCov::Formatter,
# ]
# SimpleCov.start

include Warden::Test::Helpers
Warden.test_mode!

WebMock.enable!

Capybara.javascript_driver = :selenium_chrome_headless

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.order = 'random'
  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.default_cassette_options = { :record => :new_episodes }
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data('<GITHUB_APP_PEM>') { ENV['GITHUB_APP_PEM'] }
  config.filter_sensitive_data('<GITHUB_APP_ID>') { ENV['GITHUB_APP_ID'] }
  config.filter_sensitive_data('<GITHUB_INSTALLATION_ID>') { ENV['GITHUB_INSTALLATION_ID'] }
  config.filter_sensitive_data('<GITHUB_CURRICULUM_ORGANIZATION>') { ENV['GITHUB_CURRICULUM_ORGANIZATION'] }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end