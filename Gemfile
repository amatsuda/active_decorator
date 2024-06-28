# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
end
gem 'rackup'

gem 'test-unit-rails'
gem 'capybara'
gem 'sqlite3'
gem 'webdrivers'
gem 'net-smtp'
gem 'jbuilder'
gem 'mutex_m'
gem 'base64'
gem 'bigdecimal'
