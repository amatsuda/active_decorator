module ActiveDecorator
  module Monkey
    module AbstractController
      module Rendering
        def view_assigns
          hash = super
          hash.values.each do |v|
            ActiveDecorator::Decorator.instance.decorate v
          end
          hash
        end
      end
    end
  end
end
