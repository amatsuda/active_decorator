require 'spec_helper'

describe ActiveDecorator::ORM::Mongoid do
  subject do
    MongoidDummy.create
    MongoidDummy.all.extend(ActiveDecorator::ORM::Mongoid)
  end

  it 'decorates #first' do
    subject.first.thing.should be_true
  end

  it 'decorates #last' do
    subject.last.thing.should be_true
  end

  it 'decorates #each' do
    subject.each do |document|
      document.thing.should be_true
    end
  end

  it 'decorates #map' do
    subject.map(&:thing).should == [true]
  end
end

class MongoidDummy
  include Mongoid::Document

  def thing
    false
  end
end

module MongoidDummyDecorator
  def thing
    true
  end
end
