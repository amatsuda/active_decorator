module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    #TODO need to make sure who raised the error?
    rescue NoMethodError, NameError
      begin
        (view_context = ActiveDecorator::ViewContext.current).send method, *args, &block
      rescue NoMethodError, NameError
        raise NameError, "undefined local variable or method `#{method}` for either #{self} or #{view_context}"
      end
    end
  end
end
