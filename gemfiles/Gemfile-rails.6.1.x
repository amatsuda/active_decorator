source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', '~> 6.1.0'
gem 'webdrivers'
gem 'rexml'
gem 'net-smtp'
gem 'jbuilder' unless ENV['API'] == '1'
