source 'https://rubygems.org'

gemspec path: '..'

gem 'rails', git: 'https://github.com/rails/rails', branch: '5-2-stable'
gem 'webdrivers', '< 4'
gem 'jbuilder' unless ENV['API']
