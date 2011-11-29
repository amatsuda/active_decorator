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
