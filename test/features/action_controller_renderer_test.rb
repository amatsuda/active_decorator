# frozen_string_literal: true

require 'test_helper'

class ActionControllerRendererTest < ActionDispatch::IntegrationTest
  setup do
    @matz = Author.create! name: 'matz'
    @world_of_code = @matz.books.create! title: 'the world of code'
  end

  test 'decorating a model object in ivar' do
    content = ApplicationController.renderer.render(partial: 'books/book', locals: { book: @world_of_code })
    assert content.include? 'the world of code'
    assert content.include? 'the world of code'.reverse
  end
end
