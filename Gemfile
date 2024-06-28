# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git'
  gem 'sqlite3'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
  gem 'sqlite3', '< 2'
end
gem 'rackup'

gem 'test-unit-rails'
gem 'capybara'
gem 'webdrivers'
gem 'net-smtp'
gem 'jbuilder'
gem 'mutex_m'
gem 'base64'
gem 'bigdecimal'
