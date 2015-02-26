module ActionController
  module RescueFromWithViewContext
    def rescue_with_handler(exception)
      ActiveDecorator::ViewContext.push(view_context)
      super
    ensure
      ActiveDecorator::ViewContext.pop
    end
  end
end

ActionController::Base.__send__(:prepend, ActionController::RescueFromWithViewContext)
