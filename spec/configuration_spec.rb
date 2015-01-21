require 'spec_helper'

Comic = Struct.new(:title, :price)

module ComicPresenter
  def price
    "$#{super}"
  end
end

describe ActiveDecorator::Configuration do
  let(:comic) { ActiveDecorator::Decorator.instance.decorate(Comic.new("amatsuda's (Poignant) Guide to ActiveDecorator", 3)) }

  context 'with a custom decorator_suffix' do
    before do
      ActiveDecorator.configure do |config|
        config.decorator_suffix = 'Presenter'
      end
    end

    after do
      ActiveDecorator.configure do |config|
        config.decorator_suffix = 'Decorator'
      end
    end

    specify { comic.price.should == '$3' }
  end
end
