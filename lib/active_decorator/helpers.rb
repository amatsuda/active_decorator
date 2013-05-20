module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    #TODO need to make sure who raised the error?
    rescue NoMethodError, NameError => original_error
      begin
        ActiveDecorator::ViewContext.current.send method, *args, &block
      rescue NoMethodError, NameError
        raise original_error
      end
    end

    if RUBY_VERSION >= '1.9.3'
      def respond_to_missing?(method, include_private)
        ActiveDecorator::ViewContext.current.respond_to?(method, include_private)
      end
    end
  end
end
