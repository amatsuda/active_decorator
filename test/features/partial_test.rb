# frozen_string_literal: true

require 'test_helper'

class PartialTest < ActionDispatch::IntegrationTest
  setup do
    Author.create! name: 'aamine'
  end

  test 'decorating implicit @object' do
    visit '/authors/partial'
    assert page.has_content? 'aamine'
    assert page.has_content? 'aamine'.reverse
  end

  test 'decorating implicit @collection' do
    visit '/authors/partial?pattern=collection'
    assert page.has_content? 'aamine'
    assert page.has_content? 'aamine'.reverse
  end

  test 'decorating objects in @locals' do
    visit '/authors/partial?pattern=locals'
    assert page.has_content? 'aamine'
    assert page.has_content? 'aamine'.reverse
  end
end
