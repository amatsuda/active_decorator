require 'singleton'
require 'active_decorator/helpers'

module ActiveDecorator
  class Decorator
    include Singleton

    def initialize
      @@decorators = {}
    end

    def decorate(obj)
      return if defined?(Jbuilder) && Jbuilder === obj
      return if obj.nil?

      if obj.is_a?(Array)
        obj.each do |r|
          decorate r
        end
      elsif defined?(ActiveRecord) && obj.is_a?(ActiveRecord::Relation) && !obj.respond_to?(:to_a_with_decorator)
        class << obj
          def to_a_with_decorator
            to_a_without_decorator.tap do |arr|
              ActiveDecorator::Decorator.instance.decorate arr
            end
          end
          alias_method_chain :to_a, :decorator
        end
      else
        d = decorator_for obj.class
        return obj unless d
        obj.extend d unless obj.is_a? d
      end
    end

    private
    def decorator_for(model_class)
      return @@decorators[model_class] if @@decorators.has_key? model_class

      (model_class.ancestors - model_class.included_modules).find do |candidate|
        decorator_name = "#{candidate.name}Decorator"

        begin
          d = decorator_name.constantize

          unless Class === d
            d.send :include, ActiveDecorator::Helpers
            @@decorators[model_class] = d
            return d
          end
        rescue NameError
          next
        end
      end
    end
  end
end
