module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    rescue NoMethodError, NameError
      begin
        (view_context = ActiveDecorator::ViewContext.current).send method, *args, &block
      rescue NoMethodError, NameError
        raise NameError, "undefined local variable or method `#{method}` for either #{self} or #{view_context}"
      end
    end
  end
end
