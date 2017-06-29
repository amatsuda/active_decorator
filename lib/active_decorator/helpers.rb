# frozen_string_literal: true
# On the fly delegation from the decorator to the decorated object and the helpers.
module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    rescue NoMethodError, NameError => e
      if e.name != method
        # the error is not mine, so just releases it as is.
        raise e
      end

      begin
        (view_context = ActiveDecorator::ViewContext.current).send method, *args, &block
      rescue NoMethodError => e
        if e.name != method
          raise e
        end

        raise NoMethodError.new("undefined method `#{method}' for either #{self} or #{view_context}", method)
      rescue NameError => e
        if e.name != method
          raise e
        end

        raise NameError.new("undefined local variable `#{method}' for either #{self} or #{view_context}", method)
      end
    end
  end
end
