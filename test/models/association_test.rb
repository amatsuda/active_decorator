# frozen_string_literal: true

require 'test_helper'

class AssociationTest < Test::Unit::TestCase
  test 'decorating associations' do
    a = Author.create! name: 'yugui'
    ActiveDecorator::Decorator.instance.decorate a

    b = a.books.create! title: 'giraffe'
    id = b.id

    b = a.books.first
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.last
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.find id
    assert b.is_a? ActiveDecorator::Decorated

    if ActiveRecord::VERSION::MAJOR >= 4
      b = a.books.take
      assert b.is_a? ActiveDecorator::Decorated
    end

    b = a.books.order(:id).first
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.order(:id).last
    assert b.is_a? ActiveDecorator::Decorated

    b = a.books.order(:id).find id
    assert b.is_a? ActiveDecorator::Decorated

    if ActiveRecord::VERSION::MAJOR >= 4
      b = a.books.order(:id).take
      assert b.is_a? ActiveDecorator::Decorated
    end
  end
end
