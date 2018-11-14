# frozen_string_literal: true

# On the fly delegation from the decorator to the decorated object and the helpers.
module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    rescue NoMethodError, NameError => e
      # the error is not mine, so just releases it as is.
      raise e if e.name != method

      if (view_context = ActiveDecorator::ViewContext.current)
        begin
          view_context.send method, *args, &block
        rescue NoMethodError => e
          raise e if e.name != method

          raise NoMethodError.new("undefined method `#{method}' for either #{self} or #{view_context}", method)
        rescue NameError => e
          raise e if e.name != method

          raise NameError.new("undefined local variable `#{method}' for either #{self} or #{view_context}", method)
        end
      else  # AC::API would have not view_context
        raise
      end
    end
  end
end
