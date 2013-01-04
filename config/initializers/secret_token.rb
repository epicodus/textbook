# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Textbook::Application.config.secret_token = ENV['RAILS_SECRET_TOKEN'] ||= '26f36753782bcb5406e8e83932a3f03cd424b43d909658c6dd4896bae97e4d87120e239cf72516236b8707e4f9678a67b7c00a09fc0fa3985a998577e65de37c'
