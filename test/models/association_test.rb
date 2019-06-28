# frozen_string_literal: true

require 'test_helper'

class AssociationTest < Test::Unit::TestCase
  setup do
    a = Author.create! name: 'pragdave'
    ActiveDecorator::Decorator.instance.decorate a

    @books = a.books

    b = @books.create! title: 'pragprog'
    @id = b.id
  end

  test 'build' do
    b = @books.build title: 'pickaxe'
    assert b.is_a? ActiveDecorator::Decorated
  end

  test 'create!' do
    b = @books.create! title: 'pickaxe'
    assert b.is_a? ActiveDecorator::Decorated
  end

  test 'each' do
    @books.each do |b|
      assert b.is_a? ActiveDecorator::Decorated
    end
  end

  test 'first' do
    assert @books.first.is_a? ActiveDecorator::Decorated
  end

  test 'last' do
    assert @books.last.is_a? ActiveDecorator::Decorated
  end

  test 'find' do
    assert @books.find(@id).is_a? ActiveDecorator::Decorated
  end

  test 'take' do
    assert @books.take.is_a? ActiveDecorator::Decorated
  end

  sub_test_case 'when method chained' do
    setup do
      @books = @books.order(:id)
    end

    test 'each' do
      @books.each do |b|
        assert b.is_a? ActiveDecorator::Decorated
      end
    end

    test 'first' do
      assert @books.first.is_a? ActiveDecorator::Decorated
    end

    test 'last' do
      assert @books.last.is_a? ActiveDecorator::Decorated
    end

    test 'find' do
      assert @books.find(@id).is_a? ActiveDecorator::Decorated
    end

    test 'take' do
      assert @books.take.is_a? ActiveDecorator::Decorated
    end
  end
end
