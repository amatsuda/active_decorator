# frozen_string_literal: true

require 'test_helper'

class PartialTest < ActionDispatch::IntegrationTest
  setup do
    Author.create! name: 'aamine'
    nari = Author.create! name: 'nari'
    nari.books.create! title: 'the gc book'
  end

  test 'decorating implicit @object' do
    visit '/authors'
    assert page.has_content? 'the gc book'
    assert page.has_content? 'the gc book'.reverse
  end

  test 'decorating implicit @collection' do
    visit '/authors?partial=collection'
    assert page.has_content? 'the gc book'
    assert page.has_content? 'the gc book'.reverse
  end

  test 'decorating objects in @locals' do
    visit '/authors?partial=locals'
    assert page.has_content? 'the gc book'
    assert page.has_content? 'the gc book'.upcase
  end
end
