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
  end
end
