require 'singleton'
require 'active_decorator/helpers'

module ActiveDecorator
  class Decorator
    include Singleton

    DEFAULT_NAME_RESOLVER = lambda {|model_class| "#{model_class.name}Decorator" }

    def initialize
      @@decorators   = {}
      @name_resolver = DEFAULT_NAME_RESOLVER
    end

    def resolve_decorator_with(&block)
      @@decorators.clear
      @name_resolver = block
    end

    def decorate(obj)
      return if obj.nil?

      if Array === obj
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

      decorator_name = @name_resolver.call(model_class)
      d = decorator_name.constantize
      unless Class === d
        d.send :include, ActiveDecorator::Helpers
        @@decorators[model_class] = d
      else
        @@decorators[model_class] = nil
      end
    rescue NameError
      @@decorators[model_class] = nil
    end
  end
end
