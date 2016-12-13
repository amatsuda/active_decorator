module ActiveDecorator
  module Helpers
    def method_missing(method, *args, &block)
      super
    #TODO need to make sure who raised the error?
    rescue NoMethodError, NameError => original_error
      begin
        ActiveDecorator::ViewContext.current.send method, *args, &block
      rescue NoMethodError, NameError => e
        original_error.to_s =~ %r"(`.*')"
        original_method = $1

        if e.to_s =~ %r"(`.*')" && original_method == $1
          raise original_error
        end

        original_error.message.gsub! %r"`.*'", $1
        raise original_error
      end
    end
  end
end
