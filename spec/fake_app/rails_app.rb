require 'active_record'
require 'action_controller/railtie'
require 'action_view/railtie'

require 'fake_app/models'
require 'fake_app/decorators'

# config
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

module ActiveDecoratorTestApp
  class Application < Rails::Application
    config.secret_token = '"confusion" will be my epitaph.'
    config.session_store :cookie_store, :key => '_myapp_session'
    config.active_support.deprecation = :log
  end
end
ActiveDecoratorTestApp::Application.initialize!

# routes
ActiveDecoratorTestApp::Application.routes.draw do
  resources :authors, :only => [:index, :show] do
    resources :books, :only => :show
  end
end

# helpers
module ApplicationHelper; end

# controllers
class ApplicationController < ActionController::Base
  self.append_view_path File.dirname(__FILE__)+"/rails_views"
end
class AuthorsController < ApplicationController
  def index
    if params[:variable_type] == 'array'
      @authors = Author.all
    else
      @authors = Author.scoped
    end
  end

  def show
    @author = Author.find params[:id]
  end
end
class BooksController < ApplicationController
  def show
    @book = Author.find(params[:author_id]).books.find(params[:id])
  end
end
