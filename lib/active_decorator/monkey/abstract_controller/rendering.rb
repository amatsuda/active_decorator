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
      def decorate decorate_hash
        decorate_hash.each do |k,v| 
          klass = k.to_s.camelize.constantize
          class << klass 
            attr_accessor :decorated_with
          end
          klass.decorated_with = v
        end
      end
    end
  end
end
