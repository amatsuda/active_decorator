require 'spec_helper'

describe ActiveDecorator::Decorator do
  subject do
    ActiveDecorator::Decorator.instance
  end

  describe '#decorator_for' do
    context 'when a decorator exists' do
      it 'returns the decorator' do
        subject.send(:decorator_for, Parent).should == ParentDecorator
      end
    end

    context 'when a parent decorator exists' do
      it 'returns the decorator' do
        subject.send(:decorator_for, Child).should == ParentDecorator
      end
    end
  end
end

class Parent
end

class Child < Parent
end

module ParentDecorator
end
