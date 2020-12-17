module ActiveDecorator
  module Monkey
    module ActionView
      module CollectionRenderer
        def render_collection_with_partial(collection, *)
          ActiveDecorator::Decorator.instance.decorate collection
          super
        end
      end
    end
  end
end
