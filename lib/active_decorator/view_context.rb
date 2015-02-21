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
          around_action do |controller, blk|
            begin
              ActiveDecorator::ViewContext.push controller.view_context
              blk.call
            ensure
              ActiveDecorator::ViewContext.pop
            end
          end
        else
          around_filter do |controller, blk|
            begin
              ActiveDecorator::ViewContext.push controller.view_context
              blk.call
            ensure
              ActiveDecorator::ViewContext.pop
            end
          end
        end
      end
    end
  end
end
