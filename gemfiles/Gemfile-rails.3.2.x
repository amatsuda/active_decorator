source 'https://rubygems.org'

gem 'active_decorator', :path => '..'

gem 'rails', '~> 3.2.0'
gem 'rspec-rails', '~> 2.14.0'
if RUBY_VERSION <= '1.8.7'
  gem 'i18n', '~> 0.6.11'
end
gem 'capybara', '~> 2.0.0'
# rubyzip >=1 doesn't support ruby 1.8
gem 'rubyzip', '< 1.0.0'
gem 'sqlite3'
gem 'nokogiri', '~> 1.5.0'
if RUBY_VERSION <= '1.8.7'
  gem 'jbuilder', '< 2'
else
  gem 'jbuilder'
end
gem 'test-unit'
