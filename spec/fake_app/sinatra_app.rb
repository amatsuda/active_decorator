require 'active_record'
require 'sinatra/base'

require 'fake_app/models'
require 'fake_app/decorators'

# config
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

class Sinatra::Request < Rack::Request
  def protocol
    scheme
  end
end

class ActiveDecoratorSinatraTestApp < Sinatra::Base
  register ActiveDecorator::Sinatra
  set :views, File.dirname(__FILE__)+"/sinatra_views"

  register Padrino::Helpers

  get '/authors' do
    if params[:variable_type] == 'array'
      @authors = Author.all
    else
      @authors = Author.scoped
    end

    erb :'authors/index.html'
  end

  get '/authors/:id' do
    @author = Author.find params[:id]
    erb :'authors/show.html'
  end

  get '/authors/:author_id/books/:id' do
    @book = Author.find(params[:author_id]).books.find(params[:id])
    erb :'books/show.html'
  end
end
