module ActiveDecorator
  module ViewContext
    class << self
      def current
        Thread.current[:active_decorator_view_contexts].last
      end

      def push(view_context)
        Thread.current[:active_decorator_view_contexts] ||= []
        Thread.current[:active_decorator_view_contexts] << view_context
      end

      def pop
        Thread.current[:active_decorator_view_contexts].pop if Thread.current[:active_decorator_view_contexts]
      end
    end

    module Filter
      extend ActiveSupport::Concern

      included do
        if Rails::VERSION::MAJOR >= 4
          before_action do |controller|
            ActiveDecorator::ViewContext.push controller.view_context
          end
          after_action do |controller|
            ActiveDecorator::ViewContext.pop
          end
        else
          before_filter do |controller|
            ActiveDecorator::ViewContext.push controller.view_context
          end
          after_filter do |controller|
            ActiveDecorator::ViewContext.pop
          end
        end
      end
    end
  end
end
