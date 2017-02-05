require 'spec_helper'

describe ActiveDecorator::Decorator do
  subject { ActiveDecorator::Decorator.instance }
  let(:book) { Book.new(title: 'Boek') }

  it 'returns the object on decoration' do
    subject.decorate(book).should == book
  end

  it "returns the object when it already is decorated on decorate" do
    subject.decorate(subject.decorate(book)).should == book
  end
end
