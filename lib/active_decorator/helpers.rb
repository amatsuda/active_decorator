module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    #TODO need to make sure who raised the error?
    rescue NoMethodError => no_method_error
      begin
        @_decorator_view_proxy ||= ActionView::Base.new
        @_decorator_view_proxy.send method, *args, block
      rescue NoMethodError
        raise no_method_error
      end
    end
  end
end
