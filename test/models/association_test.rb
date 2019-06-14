# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Test::Unit::TestCase
  test 'decorating associations' do
    a = Author.create! name: 'yugui'
    ActiveDecorator::Decorator.instance.decorate a

    b = a.books.create! title: 'giraffe'

    b = a.books.first
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.last
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.take
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.order(:id).first
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.order(:id).last
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.order(:id).take
    assert b.is_a? ActiveDecorator::Decorated
  end
end
