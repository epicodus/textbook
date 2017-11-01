source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~> 5.1.0'
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
end

group :test do
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'poltergeist'
  gem 'capybara'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
  gem 'lograge'
  gem 'bugsnag'
  gem 'puma'
end
