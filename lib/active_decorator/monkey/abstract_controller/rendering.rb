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
        klass.decorated_with = opts[:with] 
      end
    end
  end
end
