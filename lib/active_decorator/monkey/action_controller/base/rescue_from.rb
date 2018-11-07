# frozen_string_literal: true

# A monkey-patch for Action Controller to pass the controller view_context over
# to `render` invocation in `rescue_from` block.
module ActiveDecorator
  module Monkey
    module ActionController
      module Base
        def rescue_with_handler(*)
          ActiveDecorator::ViewContext.push(view_context)
          super
        ensure
          ActiveDecorator::ViewContext.pop
        end
      end
    end
  end
end
