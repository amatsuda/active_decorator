# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# require logger before rails or Rails 6 fails to boot
require 'logger'
# load Rails first
require 'rails'

# load the plugin
require 'active_decorator'

Bundler.require
begin
  require 'rackup/handler'
  # Work around "uninitialized constant Rack::Handler" on Capybara here: https://github.com/teamcapybara/capybara/blob/0480f90168a40780d1398c75031a255c1819dce8/lib/capybara/registrations/servers.rb#L31
  ::Rack::Handler = ::Rackup::Handler unless defined?(::Rack::Handler)
rescue LoadError
  require 'rack/handler'
end
require 'capybara'
require 'selenium/webdriver'
require 'byebug'

# needs to load the app next
require 'fake_app/fake_app'

require 'test/unit/rails/test_help'

begin
  require 'action_dispatch/system_test_case'
rescue LoadError
  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  Capybara.javascript_driver = :chrome

  class ActionDispatch::IntegrationTest
    include Capybara::DSL
  end
else
  if ActionPack::VERSION::STRING > '5.2'
    ActionDispatch::SystemTestCase.driven_by :selenium, using: :headless_chrome
  else
    ActionDispatch::SystemTestCase.driven_by :selenium_chrome_headless
  end
end

module DatabaseDeleter
  def setup
    Book.delete_all
    Author.delete_all
    Movie.delete_all
    super
  end
end

Test::Unit::TestCase.send :prepend, DatabaseDeleter

CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'authors'
