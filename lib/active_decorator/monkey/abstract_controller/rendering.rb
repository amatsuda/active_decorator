module AbstractController
  module Rendering
    def view_assigns_with_decorator
      hash = view_assigns_without_decorator
      hash.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end
      hash
    end
    alias_method_chain :view_assigns, :decorator

    module ClassMethods
      def decorate model_name, opts={} 
        raise ArgumentError unless opts.keys.include? :with
        klass = model_name.to_s.camelize.constantize
        class << klass
          attr_accessor :decorated_with
        end
        klass.decorated_with = decorator_class_with_unknown_input(opts[:with]) 
      end

      private
      def decorator_class_with_unknown_input(symbol_or_constant)
        if symbol_or_constant.is_a? Module 
          symbol_or_constant
        else
          symbol_or_constant.to_s.camelize.constantize
        end
      end
    end
  end
end
