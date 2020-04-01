source 'https://rubygems.org'

ruby '2.6.5'

gem 'rails', '~> 5.2.4'
gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'devise'
gem 'cancancan'
gem 'paranoia'
gem 'friendly_id'
gem 'textacular'
gem 'newrelic_rpm'
gem 'uglifier'
gem 'redcarpet'
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'bootstrap-multiselect-rails'
gem 'sass-rails'
gem 'mailgun-ruby', require: 'mailgun'
gem 'httparty'
gem 'jwt'
gem 'octokit'
gem 'psych'
gem "sprockets", "~> 3.7.2" # temp until issue fixed
gem 'resque'
gem 'faraday', '~> 0.17.1' # take out entirely once omniauth updates

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'rack-mini-profiler'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'pry'
  gem 'hirb'
  gem 'dotenv-rails'
end

group :test do
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'factory_bot_rails', '~> 4.11'
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'selenium-webdriver', '~> 3.141.0'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'coveralls', '~> 0.8', require: false
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'lograge'
  gem 'bugsnag'
  gem 'puma'
end
