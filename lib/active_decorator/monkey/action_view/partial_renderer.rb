# frozen_string_literal: true
module ActiveDecorator
  module Monkey
    module ActionView
      module PartialRenderer
        private

        def setup(*)
          super

          @locals.values.each do |v|
            ActiveDecorator::Decorator.instance.decorate v
          end if @locals
          ActiveDecorator::Decorator.instance.decorate @object if @object && (@object != nil)
          ActiveDecorator::Decorator.instance.decorate @collection unless @collection.blank?

          self
        end
      end
    end
  end
end
