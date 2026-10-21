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

  test 'decorating Array decorates its each element' do
    array = [Book.new(title: 'Boek')]
    assert_equal array, ActiveDecorator::Decorator.instance.decorate(array)

    array.each do |value|
      assert value.is_a?(BookDecorator)
    end
  end

  test 'decorating Hash decorates its each value' do
    hash = {some_record: Book.new(title: 'Boek')}
    assert_equal hash, ActiveDecorator::Decorator.instance.decorate(hash)

    hash.each_value do |value|
      assert value.is_a?(BookDecorator)
    end
  end

  test "Don't use the wrong decorator for nested classes" do
    comic = Foo::Comic.new

    assert_equal comic, ActiveDecorator::Decorator.instance.decorate(comic)
    assert !comic.is_a?(ComicDecorator)
  end

  test "it returns the object when nil? returns true on decorate" do
    record = NilRecord.new

    assert_equal record, ActiveDecorator::Decorator.instance.decorate(record)
    assert record.is_a?(NilRecordDecorator)
  end

  test 'nil, true, and false are not decorated' do
    assert_equal nil, ActiveDecorator::Decorator.instance.decorate(nil)
    assert_not_respond_to nil, :do
    assert_equal true, ActiveDecorator::Decorator.instance.decorate(true)
    assert_not_respond_to true, :do
    assert_equal false, ActiveDecorator::Decorator.instance.decorate(false)
    assert_not_respond_to false, :do
  end
end

class DecoratorErrorHandlingTest < Test::Unit::TestCase
  test "NameError raised while loading a decorator module is not swallowed" do
    err = assert_raises(NameError) { ActiveDecorator::Decorator.instance.decorate Typo.new }
    assert_equal :NonExistentHelper, err.name
  end
end

class DecoratorRespondToTest < Test::Unit::TestCase
  test 'decorated object responds to view helper methods within a view context' do
    book = ActiveDecorator::Decorator.instance.decorate Book.new(title: 'Boek')
    assert_respond_to book, :reverse_title
    assert_not_respond_to book, :link_to

    ActiveDecorator::ViewContext.run_with(ActionController::Base.new.view_context) do
      assert_respond_to book, :link_to
      assert_not_respond_to book, :no_such_helper
    end
  end
end
