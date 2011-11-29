# coding: utf-8
require 'spec_helper'

describe <%= singular_name.camelize %>Decorator do
  let(:<%= singular_name %>) { <%= class_name %>.new.extend <%= singular_name.camelize %>Decorator }
  subject { <%= singular_name %> }
  it { should be_a <%= class_name %> }
end
