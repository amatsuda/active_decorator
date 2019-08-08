# frozen_string_literal: true

require 'singleton'
require 'active_decorator/helpers'
require 'active_decorator/decorated'

module ActiveDecorator
  class Decorator
    include Singleton

    def initialize
      @@decorators = {}
    end

    # Decorates the given object.
    # Plus, performs special decoration for the classes below:
    #   Array: decorates its each element
    #   Hash: decorates its each value
    #   AR::Relation: decorates its each record lazily
    #   AR model: decorates its associations on the fly
    #
    # Always returns the object, regardless of whether decorated or not decorated.
    #
    # This method can be publicly called from anywhere by `ActiveDecorator::Decorator.instance.decorate(obj)`.
    def decorate(obj)
      return if defined?(Jbuilder) && (Jbuilder === obj)
      return if obj.nil?

      if obj.is_a?(Array)
        obj.each do |r|
          decorate r
        end
      elsif obj.is_a?(Hash)
        obj.each_value do |v|
          decorate v
        end
      elsif defined?(ActiveRecord) && obj.is_a?(ActiveRecord::Relation)
        # don't call each nor to_a immediately
        if obj.respond_to?(:records)
          # Rails 5.0
          obj.extend ActiveDecorator::RelationDecorator unless obj.is_a? ActiveDecorator::RelationDecorator
        else
          # Rails 3.x and 4.x
          obj.extend ActiveDecorator::RelationDecoratorLegacy unless obj.is_a? ActiveDecorator::RelationDecoratorLegacy
        end
      else
        if defined?(ActiveRecord) && obj.is_a?(ActiveRecord::Base) && !obj.is_a?(ActiveDecorator::Decorated)
          obj.extend ActiveDecorator::Decorated
        end

        d = decorator_for obj.class
        return obj unless d
        obj.extend d unless obj.is_a? d
      end

      obj
    end

    # Decorates AR model object's association only when the object was decorated.
    # Returns the association instance.
    def decorate_association(owner, target)
      owner.is_a?(ActiveDecorator::Decorated) ? decorate(target) : target
    end

    private
    # Returns a decorator module for the given class.
    # Returns `nil` if no decorator module was found.
    def decorator_for(model_class)
      return @@decorators[model_class] if @@decorators.key? model_class

      decorator_name = "#{model_class.name}#{ActiveDecorator.config.decorator_suffix}"
      d = decorator_name.constantize
      unless Class === d
        d.send :include, ActiveDecorator::Helpers
        @@decorators[model_class] = d
      else
        # Cache nil results
        @@decorators[model_class] = nil
      end
    rescue NameError
      if model_class.respond_to?(:base_class) && (model_class.base_class != model_class)
        @@decorators[model_class] = decorator_for model_class.base_class
      else
        # Cache nil results
        @@decorators[model_class] = nil
      end
    end
  end

  # For AR 3 and 4
  module RelationDecoratorLegacy
    def to_a
      ActiveDecorator::Decorator.instance.decorate super
    end
  end

  # For AR 5+
  module RelationDecorator
    def records
      ActiveDecorator::Decorator.instance.decorate super
    end
  end
end
