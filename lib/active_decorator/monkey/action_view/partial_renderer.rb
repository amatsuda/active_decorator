module ActionView
  class PartialRenderer < AbstractRenderer #:nodoc:
    def setup_with_decorator(context, options, block)
      setup_without_decorator context, options, block

      @locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end if @locals.present?
      ActiveDecorator::Decorator.instance.decorate @object
      ActiveDecorator::Decorator.instance.decorate @collection if @collection.present?

      self
    end

    alias_method_chain :setup, :decorator
  end
end
