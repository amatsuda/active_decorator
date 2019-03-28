# frozen_string_literal: true

require 'test_helper'

class DecoratorTest < Test::Unit::TestCase

  test 'it returns the object on decoration' do
    book = Book.new title: 'Boek'
    assert_equal book, ActiveDecorator::Decorator.instance.decorate(book)
  end

  test 'it returns the object when it already is decorated on decorate' do
    book = Book.new title: 'Boek'
    assert_equal book, ActiveDecorator::Decorator.instance.decorate(ActiveDecorator::Decorator.instance.decorate(book))
  end

  test 'it returns the object of ActiveRecord::Relation on decorate' do
    3.times do |index|
      Book.create title: "ve#{index}"
    end

    books = Book.all
    assert_equal books, ActiveDecorator::Decorator.instance.decorate(books)
  end

  test 'it returns the object of ActiveRecord::Relation when it already is decorated on decorate' do
    3.times do |index|
      Book.create title: "ve#{index}"
    end

    books = Book.all
    assert_equal books, ActiveDecorator::Decorator.instance.decorate(ActiveDecorator::Decorator.instance.decorate(books))
  end

  test 'it returns the object of Hash on decoration' do
    book_in_hash = { some_record: Book.new(title: 'Boek') }
    assert_equal book_in_hash, ActiveDecorator::Decorator.instance.decorate(book_in_hash)
  end

  test 'it returns the object of Hash when it already is decorated on decorate' do
    book_in_hash = { some_record: Book.new(title: 'Boek') }
    assert_equal book_in_hash, ActiveDecorator::Decorator.instance.decorate(ActiveDecorator::Decorator.instance.decorate(book_in_hash))
  end

  test 'The object in Hash has all the methods included by its Decorator' do
    book = Book.new(title: 'Boek')
    ActiveDecorator::Decorator.instance.decorate(some_record: book)
    decorator = ActiveDecorator::Decorator.instance
                                          .send(:decorator_for, book.class)

    assert(decorator.instance_methods.all? { |d| book.methods.include?(d) })
  end
end
