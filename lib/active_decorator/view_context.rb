module ActiveDecorator
  module ViewContext
    class << self
      def current
        Thread.current[:view_context]
      end

      def current=(view_context)
        Thread.current[:view_context] = view_context
      end
    end

    module Filter
      extend ActiveSupport::Concern

      included do
        if Rails::VERSION::MAJOR >= 4
          before_action do |controller|
            ActiveDecorator::ViewContext.current = controller.view_context
          end
        else
          before_filter do |controller|
            ActiveDecorator::ViewContext.current = controller.view_context
          end
        end
      end
    end
  end
end
