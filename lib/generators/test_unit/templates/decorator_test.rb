# coding: utf-8
require 'test_helper'

class <%= singular_name.camelize %>DecoratorTest < ActiveSupport::TestCase
  def setup
    @<%= singular_name %> = <%= class_name %>.new.extend <%= singular_name.camelize %>Decorator
  end

  # test "the truth" do
  #   assert true
  # end
end
