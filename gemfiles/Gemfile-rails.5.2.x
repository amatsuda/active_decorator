source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 5.2.0'
gem 'webdrivers', '< 4'
gem 'jbuilder' unless ENV['API'] == '1'
