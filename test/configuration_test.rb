# frozen_string_literal: true

require 'test_helper'

Comic = Struct.new(:title, :price)

module ComicPresenter
  def price
    "$#{super}"
  end
end

class ConfigurationTest < Test::Unit::TestCase
  test 'with a custom decorator_suffix' do
    begin
      ActiveDecorator.configure do |config|
        config.decorator_suffix = 'Presenter'
      end

      comic = ActiveDecorator::Decorator.instance.decorate Comic.new("amatsuda's (Poignant) Guide to ActiveDecorator", 3)
      assert_equal '$3', comic.price
    ensure
      ActiveDecorator.configure do |config|
        config.decorator_suffix = 'Decorator'
      end
    end
  end
end
