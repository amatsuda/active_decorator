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

::ActionController::Base.send :prepend, ActiveDecorator::Monkey::ActionController::Base
