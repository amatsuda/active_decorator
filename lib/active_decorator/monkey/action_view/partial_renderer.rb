# frozen_string_literal: true

# A monkey-patch for Action View `render :partial` that auto-decorates `locals` values.
module ActiveDecorator
  module Monkey
    module ActionView
      module PartialRenderer

        if (Rails::VERSION::MAJOR > 6) || (Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR >= 1)
          def render(*)
            @locals.each_value do |v|
              ActiveDecorator::Decorator.instance.decorate v
            end if @locals
            ActiveDecorator::Decorator.instance.decorate @object if @object
            ActiveDecorator::Decorator.instance.decorate @collection unless @collection.blank?

            super
          end
        end

        private

        if (Rails::VERSION::MAJOR < 6) || (Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR < 1)
          def setup(*)
            super

            @locals.each_value do |v|
              ActiveDecorator::Decorator.instance.decorate v
            end if @locals
            ActiveDecorator::Decorator.instance.decorate @object if @object
            ActiveDecorator::Decorator.instance.decorate @collection unless @collection.blank?

            self
          end
        end
      end
    end
  end
end
