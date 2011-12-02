require 'singleton'
require 'active_decorator/helpers'

module ActiveDecorator
  class Decorator
    include Singleton

    def initialize
      @@decorators = {}
    end

    def decorate_if_model(obj)
      case obj
      when ActiveRecord::Base
        decorate obj
      when ActiveRecord::Relation
        class << obj
          def to_a_with_decorator
            arr = to_a_without_decorator
            arr.each do |model|
              ActiveDecorator::Decorator.instance.decorate model
            end
          end
          alias_method_chain :to_a, :decorator
        end
      when Array
        obj.each do |r|
          decorate_if_model r
        end
      end
    end

    def decorate(model)
      d = decorator_for model.class
      return model unless d
      model.extend d unless model.is_a? d
    end

    private
    def decorator_for(model_class)
      return @@decorators[model_class] if @@decorators.has_key? model_class

      decorator_name = "#{model_class.name}Decorator"
      d = decorator_name.constantize
      d.send :include, ActiveDecorator::Helpers
      @@decorators[model_class] = d
      rescue NameError
    end
  end
end
