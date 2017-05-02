require 'test_helper'

Comic = Struct.new(:title, :price)

module ComicPresenter
  def price
    "$#{super}"
  end
end

class DoubleDecorateTest < Test::Unit::TestCase
  test 'with decorate idempotence' do
    comic = ActiveDecorator::Decorator.instance.decorate Comic.new("amatsuda's (Poignant) Guide to ActiveDecorator", 3)
    comic = ActiveDecorator::Decorator.instance.decorate comic
    assert_equal '$3', comic.price
  end
end
