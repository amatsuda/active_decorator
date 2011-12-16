module AbstractController
  module Rendering
    def view_assigns_with_decorator
      hash = view_assigns_without_decorator
      hash.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end
      hash
    end

    alias_method_chain :view_assigns, :decorator
  end
end
