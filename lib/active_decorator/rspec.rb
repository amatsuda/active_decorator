module RSpec::Rails
  module DecoratorExampleGroup
    extend ActiveSupport::Concern
    include RSpec::Rails::RailsExampleGroup
    include ActionView::TestCase::Behavior

    def decorate(obj)
      ActiveDecorator::Decorator.instance.decorate(obj)
      obj
    end

    included do
      metadata[:type] = :decorator

      before do
        ActiveDecorator::ViewContext.current = controller.view_context
      end
    end
  end
end

RSpec::configure do |c|
  c.include RSpec::Rails::DecoratorExampleGroup, :type => :decorator, :example_group => {
    :file_path => c.escaped_path(%w[spec decorators])
  }
end
