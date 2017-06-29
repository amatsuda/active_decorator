# frozen_string_literal: true
require 'test_helper'

class NameErrorHandlingTest < ActionDispatch::IntegrationTest
  setup do
    aamine = Author.create! name: 'aamine'
    @rhg = aamine.books.create! title: 'RHG'
  end

  test 'raising NameError in a decorator' do
    err = assert_raises ActionView::Template::Error do
      visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}/errata"
    end

    assert_match(/undefined method `poof!' for/, err.message)
    assert_match 'poof!', err.cause.name if err.respond_to?(:cause)
  end
end
