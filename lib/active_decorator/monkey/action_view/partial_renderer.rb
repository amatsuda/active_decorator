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

  # patch for : <%= render template: 'my_view', :locals => {:foo => foo} %>
  class ActionView::TemplateRenderer
    def render_template_with_decorator(template, layout_name = nil, locals = {}) #:nodoc:
      # apply decorate for locals
      locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end unless locals.blank?

      render_template_without_decorator(template, layout_name, locals)
    end

    alias_method_chain :render_template, :decorator
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
