source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 5.0.0'
gem 'sqlite3', '< 1.4'
gem 'jbuilder' unless ENV['API'] == '1'
