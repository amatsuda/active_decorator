# frozen_string_literal: true
require 'test_helper'

if Rails::VERSION::MAJOR >= 5

class ActionControllerAPITest < ActionDispatch::IntegrationTest
  setup do
    nari = Author.create! name: 'nari'
    nari.books.create! title: 'the gc book'
  end

  test 'decorating objects in api only controllers' do
    visit "/api/authors/#{Author.last.id}.json"

    assert_equal '{"name":"nari","books":[{"title":"the gc book","reverse_title":"koob cg eht"}]}', page.source
  end
end

end
