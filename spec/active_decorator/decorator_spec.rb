require 'spec_helper'

class MyModel
end

module MyModelPresenter
  def greet
    'Hi from Presenter'
  end
end

describe ActiveDecorator::Decorator do
  context 'customize decorator name resolving' do
    before(:all) do
      ActiveDecorator::Decorator.instance.resolve_decorator_with do |name|
        "#{name}Presenter"
      end
    end

    after(:all) do
      ActiveDecorator::Decorator.instance.resolve_decorator_with(&ActiveDecorator::Decorator::DEFAULT_NAME_RESOLVER)
    end

    let(:my_model) do
      ActiveDecorator::Decorator.instance.decorate(MyModel.new)
    end

    specify { my_model.greet.should == 'Hi from Presenter' }
  end
end

