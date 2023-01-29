# frozen_string_literal: true

require 'singleton'
require 'active_decorator/helpers'
require 'active_decorator/decorated'

module ActiveDecorator
  class Decorator
    include Singleton

    def initialize
      @decorators = {}
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
      return obj if defined?(Jbuilder) && (Jbuilder === obj)

      case obj
      when Array
        obj.each {|e| decorate e }
      when Hash
        obj.each_value {|v| decorate v }
      when nil, true, false
        # Do nothing
      else
        if defined? ActiveRecord
          if obj.is_a? ActiveRecord::Relation
            return decorate_relation obj
          elsif ActiveRecord::Base === obj
            obj.extend ActiveDecorator::Decorated unless ActiveDecorator::Decorated === obj
          end
        end

        d = decorator_for obj.class
        obj.extend d if d && !(d === obj)
      end

      obj
    end

    # Decorates AR model object's association only when the object was decorated.
    # Returns the association instance.
    def decorate_association(owner, target)
      (ActiveDecorator::Decorated === owner) ? decorate(target) : target
    end

    private
    # Returns a decorator module for the given class.
    # Returns `nil` if no decorator module was found.
    def decorator_for(model_class)
      return @decorators[model_class] if @decorators.key? model_class

      decorator_name = "#{model_class.name}#{ActiveDecorator.config.decorator_suffix}"
      d = decorator_name.constantize
      unless Class === d
        d.send :include, ActiveDecorator::Helpers
        @decorators[model_class] = d
      else
        # Cache nil results
        @decorators[model_class] = nil
      end
    rescue NameError
      if model_class.respond_to?(:base_class) && (model_class.base_class != model_class)
        @decorators[model_class] = decorator_for model_class.base_class
      else
        # Cache nil results
        @decorators[model_class] = nil
      end
    end

    # Decorate with proper monkey patch based on AR version
    def decorate_relation(obj)
      if obj.respond_to?(:records)
        # Rails 5.0
        obj.extend ActiveDecorator::RelationDecorator unless ActiveDecorator::RelationDecorator === obj
      else
        # Rails 3.x and 4.x
        obj.extend ActiveDecorator::RelationDecoratorLegacy unless ActiveDecorator::RelationDecoratorLegacy === obj
      end
      obj
    end
  end

  # Override AR::Relation#records to decorate each element after being loaded (for AR 5+)
  module RelationDecorator
    def records
      ActiveDecorator::Decorator.instance.decorate super
    end
  end

  # Override AR::Relation#to_a to decorate each element after being loaded (for AR 3 and 4)
  module RelationDecoratorLegacy
    def to_a
      ActiveDecorator::Decorator.instance.decorate super
    end
  end
end
