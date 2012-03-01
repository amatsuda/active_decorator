module ActiveDecorator
  module ActionViewExtension
    def setup_decorator
      @locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end unless @locals.blank?
      ActiveDecorator::Decorator.instance.decorate @object unless @object.blank?
      ActiveDecorator::Decorator.instance.decorate @collection unless @collection.blank?

      self
    end
  end
end

if ActionPack::VERSION::STRING >= '3.1'
  class ActionView::PartialRenderer
    include ActiveDecorator::ActionViewExtension

    def setup_with_decorator(context, options, block) #:nodoc:
      setup_without_decorator context, options, block
      setup_decorator
    end

    alias_method_chain :setup, :decorator
  end
else
  class ActionView::Partials::PartialRenderer
    include ActiveDecorator::ActionViewExtension

    def setup_with_decorator(options, block) #:nodoc:
      setup_without_decorator options, block
      setup_decorator
    end

    alias_method_chain :setup, :decorator
  end
end
