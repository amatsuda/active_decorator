source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 4.2.0'
gem 'sqlite3', '< 1.4'
gem 'nokogiri', '~> 1.6.0'
gem 'jbuilder' unless ENV['API']
