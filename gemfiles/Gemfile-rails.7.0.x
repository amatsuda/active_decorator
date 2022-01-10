source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 7.0.0'
gem 'webdrivers'
gem 'jbuilder' unless ENV['API'] == '1'
