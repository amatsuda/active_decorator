require 'active_decorator/version'

module ActiveDecorator
  def self.decorate_if_model(obj)
    case obj
    when ActiveRecord::Base
      ActiveDecorator.decorate obj
    when ActiveRecord::Relation
      class << obj
        def to_a_with_decorator
          arr = to_a_without_decorator
          ActiveDecorator.decorate_all arr
        end
        alias_method_chain :to_a, :decorator
      end
    when Array
      obj.each do |r|
        ActiveDecorator.decorate r
      end
    end
  end

  def self.decorate_all(models)
    return if models.empty?
    decorator_name = "#{models.first.class.name}Decorator"
    k = decorator_name.constantize
    models.each do |m|
      m.extend k unless m.is_a? k
    end
    rescue NameError
  end

  def self.decorate(model)
    decorator_name = "#{model.class.name}Decorator"
    k = decorator_name.constantize
    model.extend k unless model.is_a? k
    rescue NameError
  end
end

module AbstractController
  module Rendering
    def view_assigns_with_decorator
      hash = view_assigns_without_decorator
      hash.values.each do |v|
        ActiveDecorator.decorate_if_model v
      end
      hash
    end

    alias_method_chain :view_assigns, :decorator
  end
end

module ActionView
  class PartialRenderer < AbstractRenderer #:nodoc:
    def setup_with_decorator(context, options, block)
      setup_without_decorator context, options, block

      @locals.values.each do |v|
        ActiveDecorator.decorate_if_model v
      end if @locals.present?
      ActiveDecorator.decorate_if_model @object
      @collection.each do |v|
        ActiveDecorator.decorate_if_model v
      end if @collection.present?

      self
    end

    alias_method_chain :setup, :decorator
  end
end
