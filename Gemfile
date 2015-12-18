source 'https://rubygems.org'

ruby '2.2.4'

gem 'rails', '~> 4.2.1'
gem 'pg'
gem 'unicorn'
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

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "letter_opener"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'pry'
end

group :test do
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
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
end
