source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 6.1.0'
gem 'webdrivers'
gem 'jbuilder' unless ENV['API']
