require 'spec_helper'

describe ActiveDecorator::Decorator do
  subject do
    ActiveDecorator::Decorator.instance
  end

  describe '#decorate' do
    context 'Mongoid::Criteria' do
      let(:criteria) {Mongoid::Criteria.new(MongoidDummy)}

      it 'is extended with ORM::Mongoid' do
        criteria.should_receive(:extend).with(ActiveDecorator::ORM::Mongoid)
        subject.decorate(criteria)
      end
    end
  end
end

class MongoidDummy
  include Mongoid::Document
end

module MongoidDummyDecorator
end
