# config
require 'rails'
require 'active_decorator'

# database
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

module ActiveDecoratorTestApp
  class Application < Rails::Application
    config.secret_token = '"confusion" will be my epitaph.'
    config.session_store :cookie_store, :key => '_myapp_session'
    config.active_support.deprecation = :log
  end
end

# routes
ActiveDecoratorTestApp::Application.routes.draw do
  resources :authors, :only => [:index, :show]
end

# models
class Author < ActiveRecord::Base
  has_many :books
end
class Book < ActiveRecord::Base
  belongs_to :author
end

# helpers
module ApplicationHelper; end

# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name}
    create_table(:books) {|t| t.string :title; t.references :author}
  end
end
