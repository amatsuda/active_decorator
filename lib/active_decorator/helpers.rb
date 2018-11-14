# frozen_string_literal: true

# On the fly delegation from the decorator to the decorated object and the helpers.
module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    rescue NoMethodError, NameError => e1
      # the error is not mine, so just releases it as is.
      raise e1 if e1.name != method

      if (view_context = ActiveDecorator::ViewContext.current)
        begin
          view_context.send method, *args, &block
        rescue NoMethodError => e2
          raise e2 if e2.name != method

          raise NoMethodError.new("undefined method `#{method}' for either #{self} or #{view_context}", method)
        rescue NameError => e2
          raise e2 if e2.name != method

          raise NameError.new("undefined local variable `#{method}' for either #{self} or #{view_context}", method)
        end
      else  # AC::API would have not view_context
        raise e1
      end
    end
  end
end
