source 'https://rubygems.org'

gem 'active_decorator', path: '..'

gem 'rails', '~> 4.2.0'
gem 'test-unit-rails'
gem 'capybara'
gem 'sqlite3'
gem 'jbuilder'
gem 'nokogiri', '< 1.7.0' if RUBY_VERSION.to_f < 2.1
