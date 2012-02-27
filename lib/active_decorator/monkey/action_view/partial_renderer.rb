if ActionPack::VERSION::STRING >= '3.1'
  class ActionView::PartialRenderer
    def setup_with_decorator(context, options, block) #:nodoc:
      setup_without_decorator context, options, block

      @locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end if @locals.present?
      ActiveDecorator::Decorator.instance.decorate @object if @object.present?
      ActiveDecorator::Decorator.instance.decorate @collection if @collection.present?

      self
    end

    alias_method_chain :setup, :decorator
  end
else
  class ActionView::Partials::PartialRenderer
    def setup_with_decorator(options, block) #:nodoc:
      setup_without_decorator options, block

      @locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end if @locals.present?
      ActiveDecorator::Decorator.instance.decorate @object if @object.present?
      ActiveDecorator::Decorator.instance.decorate @collection if @collection.present?

      self
    end

    alias_method_chain :setup, :decorator
  end
end
