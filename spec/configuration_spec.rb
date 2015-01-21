require 'spec_helper'

Comic = Struct.new(:title, :price)

module ComicPresenter
  def price
    "$#{super}"
  end
end

describe ActiveDecorator::Configuration do
  let(:comic) { Comic.new("amatsuda's (Poignant) Guide to ActiveDecorator", 3) }

  before do
    ActiveDecorator.configure do |config|
      config.decorator_suffix = 'Presenter'
    end

    ActiveDecorator::Decorator.instance.decorate(comic)
  end

  after do
    ActiveDecorator.configure do |config|
      config.decorator_suffix = 'Decorator'
    end
  end

  it 'must use ComicPresenter' do
    expect(comic.price).to eq '$3'
  end
end
