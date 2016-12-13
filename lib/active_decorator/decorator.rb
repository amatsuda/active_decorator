# frozen_string_literal: true
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
        d = decorator_for obj.class
        return obj unless d
        obj.extend d unless obj.is_a? d
      end
    end

    private
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

  module RelationDecoratorLegacy
    def to_a
      super.tap do |arr|
        ActiveDecorator::Decorator.instance.decorate arr
      end
    end
  end

  module RelationDecorator
    def records
      super.tap do |arr|
        ActiveDecorator::Decorator.instance.decorate arr
      end
    end
  end
end
