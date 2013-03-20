$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

begin
  # load Rails first
  require 'rails'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'capybara/rspec'

if defined? Rails
  require 'active_decorator'
  # needs to load the app before loading rspec/rails => capybara
  require 'fake_app/rails_app'
  require 'rspec/rails'

  def rails?; true end
end
if defined? Sinatra
  require 'active_decorator/sinatra'
  require 'fake_app/sinatra_app'
  require 'rack/test'
  require 'sinatra/test_helpers'

  def rails?; false end

  Capybara.app = ActiveDecoratorSinatraTestApp

  RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.include Sinatra::TestHelpers
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before :all do
    CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'authors'
  end
  config.before :each do
    Book.delete_all
    Author.delete_all
  end
end
