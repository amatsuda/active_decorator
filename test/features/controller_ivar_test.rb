# frozen_string_literal: true

require 'test_helper'

class ControllerIvarTest < ActionDispatch::IntegrationTest
  setup do
    @matz = Author.create! name: 'matz'
    @matz.books.create! title: 'the world of code'
    Author.create! name: 'takahashim'
  end

  test 'decorating a model object in ivar' do
    visit "/authors/#{@matz.id}"
    assert page.has_content? 'matz'
    assert page.has_content? 'matz'.capitalize
  end

  test 'decorating model scope in ivar' do
    visit '/authors'
    assert page.has_content? 'takahashim'
    assert page.has_content? 'takahashim'.reverse
  end

  test "decorating models' array in ivar" do
    visit '/authors?variable_type=array'
    assert page.has_content? 'takahashim'
    assert page.has_content? 'takahashim'.reverse
  end

  test "decorating models' proxy object in ivar" do
    visit '/authors?variable_type=proxy'
    assert page.has_content? 'takahashim'
    assert page.has_content? 'takahashim'.reverse
  end

  test 'decorating model association proxy in ivar' do
    visit "/authors/#{@matz.id}/books"
    assert page.has_content? 'the world of code'
    assert page.has_content? 'the world of code'.reverse
  end
end
