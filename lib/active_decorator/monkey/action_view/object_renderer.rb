module ActiveDecorator
  module Monkey
    module ActionView
      module ObjectRenderer
        def render_object_with_partial(object, *)
          ActiveDecorator::Decorator.instance.decorate object
          super
        end
      end
    end
  end
end
