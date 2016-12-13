# frozen_string_literal: true
module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    rescue NoMethodError, NameError
      begin
        (view_context = ActiveDecorator::ViewContext.current).send method, *args, &block
      rescue NoMethodError
        raise NoMethodError, "undefined method `#{method}` for either #{self} or #{view_context}"
      rescue NameError
        raise NameError, "undefined local variable `#{method}` for either #{self} or #{view_context}"
      end
    end
  end
end
