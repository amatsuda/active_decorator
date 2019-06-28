# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'ostruct'
require 'jbuilder'

# config
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

module ActiveDecoratorTestApp
  class Application < Rails::Application
    config.secret_token = '"confusion" will be my epitaph.'
    config.session_store :cookie_store, key: '_myapp_session'
    config.active_support.deprecation = :log
    config.eager_load = false
    config.action_dispatch.show_exceptions = false
    config.root = File.dirname(__FILE__)

    config.action_mailer.delivery_method = :test
  end
end
ActiveDecoratorTestApp::Application.initialize!

# routes
ActiveDecoratorTestApp::Application.routes.draw do
  resources :authors, only: [:index, :show] do
    resources :books, only: [:index, :show] do
      member do
        get :errata
        get :errata2
        get :error
        post :purchase
      end
    end
    resources :novels, only: [:index, :show] do
      member do
        get :error
        post :purchase
      end
    end
  end
  resources :movies, only: :show

  if Rails::VERSION::MAJOR >= 5
    namespace :api do
      resources :bookstores, only: :show
    end
  end
end

# models
class Author < ActiveRecord::Base
  has_many :books
  has_many :publishers, through: :books
  has_many :movies
  has_one :profile
  has_one :profile_history, through: :profile
  has_and_belongs_to_many :magazines
  belongs_to :company
end
class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :publisher
  accepts_nested_attributes_for :publisher
end
class Novel < Book
end
class Movie < ActiveRecord::Base
  belongs_to :author
end
class Publisher < ActiveRecord::Base
  has_many :books
end
class Profile < ActiveRecord::Base
  belongs_to :author
  has_one :profile_history
  accepts_nested_attributes_for :profile_history
end
class ProfileHistory < ActiveRecord::Base
  belongs_to :profile
end
class Magazine < ActiveRecord::Base
  has_and_belongs_to_many :authors
end
class Company < ActiveRecord::Base
  has_many :authors
end
class Bookstore < ActiveRecord::Base
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
end
module BookDecorator
  def reverse_title
    title.reverse
  end

  def upcased_title
    title.upcase
  end

  def link
    link_to title, "#{request.protocol}#{request.host_with_port}/assets/sample.png", class: 'title'
  end

  def cover_image
    image_tag 'cover.png'
  end

  def errata
    poof!
  end

  def errata2
    title.boom!
  end

  def error
    "ERROR"
  end
end
module PublisherDecorator
  def upcased_name
    name.upcase
  end

  def reversed_name
    name.reverse
  end
end
module ProfileDecorator
  def address
    "secret"
  end
end
module ProfileHistoryDecorator
  def update_date
    updated_on.strftime('%Y/%m/%d')
  end
end
module MagazineDecorator
  def upcased_title
    title.upcase
  end
end
module CompanyDecorator
  def reverse_name
    name.reverse
  end
end

# decorator fake
class MovieDecorator; end

# controllers
unless ENV['API']
  class ApplicationController < ActionController::Base
    self.append_view_path File.dirname(__FILE__)
  end
  class AuthorsController < ApplicationController
    def index
      # ActiveRecord 4.x
      if params[:variable_type] == 'array'
        @authors = Author.all.to_a
      elsif params[:variable_type] == 'proxy'
        @authors = RelationProxy.new(Author.all)
      else
        @authors = Author.all
      end
    end

    def show
      @author = Author.find params[:id]
    end
  end
  class BooksController < ApplicationController
    class CustomError < StandardError; end

    rescue_from CustomError do
      render :error
    end

    def index
      @author = Author.find params[:author_id]
      @books  = @author.books
    end

    def show
      @book = Author.find(params[:author_id]).books.find(params[:id])
    end

    def errata
      @book = Author.find(params[:author_id]).books.find(params[:id])
    end

    def errata2
      @book = Author.find(params[:author_id]).books.find(params[:id])
    end

    def error
      @book = Author.find(params[:author_id]).books.find(params[:id])
      raise CustomError, "error"
    end

    def purchase
      @book = Author.find(params[:author_id]).books.find(params[:id])

      @view_context_before_sending_mail = ActiveDecorator::ViewContext.current
      BookMailer.thanks(@book).deliver
      raise 'Wrong ViewContext!' if ActiveDecorator::ViewContext.current != @view_context_before_sending_mail
    end
  end
  class MoviesController < ApplicationController
    def show
      @movie = Movie.find params[:id]
    end
  end
else
  module Api
    class BookstoresController < ActionController::API
      def show
        @bookstore = Bookstore.find params[:id]
      end
    end
  end
end

# mailers
class BookMailer < ActionMailer::Base
  def thanks(book)
    @book = book
    mail from: 'nobody@example.com', to: 'test@example.com', subject: 'Thanks'
  end
end

# migrations
class CreateAllTables < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name; t.references :company}
    create_table(:books) {|t| t.string :title; t.string :type; t.references :author; t.references :publisher }
    create_table(:profiles) {|t| t.string :address; t.references :author}
    create_table(:profile_histories) {|t| t.date :updated_on; t.references :profile}
    create_table(:publishers) {|t| t.string :name}
    create_table(:movies) {|t| t.string :name; t.references :author}
    create_table(:magazines) {|t| t.string :title}
    create_table(:authors_magazines) {|t| t.references :author; t.references :magazine}
    create_table(:companies) {|t| t.string :name}
    create_table(:bookstores) {|t| t.string :name}
  end
end

# Proxy for ActiveRecord::Relation
class RelationProxy < BasicObject
  attr_accessor :ar_relation

  def initialize(ar_relation)
    @ar_relation = ar_relation
  end

  def method_missing(method, *args, &block)
    @ar_relation.public_send(method, *args, &block)
  end
end
