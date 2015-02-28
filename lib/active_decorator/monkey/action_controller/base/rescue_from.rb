module ActionController
  class Base
    def rescue_with_handler_with_decorator_view_context(exception)
      ActiveDecorator::ViewContext.push(view_context)
      rescue_with_handler_without_decorator_view_context(exception)
    ensure
      ActiveDecorator::ViewContext.pop
    end
    alias_method_chain :rescue_with_handler, :decorator_view_context
  end
end
