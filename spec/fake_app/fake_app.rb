require 'active_record'
require 'action_controller/railtie'
require 'action_view/railtie'

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
  resources :movies, :only => :show
end

# models
class Author < ActiveRecord::Base
  has_many :books
end
class Book < ActiveRecord::Base
  belongs_to :author
end
class Movie < ActiveRecord::Base
end

# helpers
module ApplicationHelper; end

# decorators
module AuthorDecorator
  def reverse_name
    name.reverse
  end

  def capitalized_name
    name.capitalize
  end

  def current_user_id_respond_to?
    respond_to?(:current_user_id)
  end
end
module BookDecorator
  def reverse_title
    title.reverse
  end

  def upcased_title
    title.upcase
  end

  def link
    link_to title, "#{request.protocol}#{request.host_with_port}/assets/sample.png"
  end

  def cover_image
    image_tag 'cover.png'
  end
end

# decorator fake
class MovieDecorator; end

# controllers
class ApplicationController < ActionController::Base
  self.append_view_path File.dirname(__FILE__)
  private
  def current_user_id
    1
  end
  helper_method :current_user_id
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
class MoviesController < ApplicationController
  def show
    @movie = Movie.find params[:id]
  end
end

# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name}
    create_table(:books) {|t| t.string :title; t.references :author}
    create_table(:movies) {|t| t.string :name}
  end
end
