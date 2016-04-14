module ActiveDecorator
  module Monkey
    module ActionView
      module PartialRenderer
        private

        def setup(*)
          super

          @locals.values.each do |v|
            ActiveDecorator::Decorator.instance.decorate v
          end unless @locals.blank?
          ActiveDecorator::Decorator.instance.decorate @object unless @object.blank?
          ActiveDecorator::Decorator.instance.decorate @collection unless @collection.blank?

          self
        end
      end
    end
  end
end
