require 'test_helper'

<% module_namespacing do -%>
class <%= class_name %>DecoratorTest < ActiveSupport::TestCase
  def setup
    @<%= singular_name %> = <%= class_name %>.new.extend <%= class_name %>Decorator
  end

  # test "the truth" do
  #   assert true
  # end
end
<% end -%>
