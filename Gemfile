# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git'
  gem 'rackup'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
  gem 'sqlite3', '< 1.4' if ENV['RAILS_VERSION'] <= '5.0'
  gem 'rackup' if ENV['RAILS_VERSION'] > '7.1'
else
  gem 'rails'
end

if RUBY_VERSION < '2.7'
  gem 'puma', '< 6'
else
  gem 'puma'
end

gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '< 2.21.0' : '>= 0'
gem 'concurrent-ruby', RUBY_VERSION < '2.3' ? '~> 1.1.0' : '>= 1.2'
gem 'selenium-webdriver', RUBY_VERSION == '3.0' ? '4.9.0' : '>= 0'
gem 'webdrivers' if ENV['RAILS_VERSION'] && ENV['RAILS_VERSION'] >= '6'
gem 'net-smtp' if RUBY_VERSION >= '3.1'
gem 'jbuilder' unless ENV['API'] == '1'
