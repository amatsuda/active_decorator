require 'test_helper'

class <%= singular_name.camelize %>DecoratorTest < ActiveSupport::TestCase
  def setup
    @<%= singular_name %> = <%= class_name %>.new.extend <%= class_name %>Decorator
  end

  # test "the truth" do
  #   assert true
  # end
end
