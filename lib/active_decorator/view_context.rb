# frozen_string_literal: true

# A module that carries the controllers' view_context to decorators.
module ActiveDecorator
  # Use Rails' CurrentAttributes if available (Rails 5.2+)
  if defined? ActiveSupport::CurrentAttributes
    class ViewContext < ActiveSupport::CurrentAttributes
      # Rails 7.2+
      if method(:attribute).parameters.include? [:key, :default]
        attribute :view_context_stack, default: []
      else
        attribute :view_context_stack

        def view_context_stack
          attributes[:view_context_stack] ||= []
        end
      end

      resets do
        self.view_context_stack = nil
      end
    end
  else
    # Fallback implementation for Rails < 5.2
    class ViewContext
      class << self
        def view_context_stack
          Thread.current[:active_decorator_view_contexts] ||= []
        end
      end
    end
  end

  class ViewContext
    class << self
      def current
        view_context_stack.last
      end

      def push(view_context)
        view_context_stack.push view_context
      end

      def pop
        view_context_stack.pop
      end

      def run_with(view_context)
        push view_context
        yield
      ensure
        pop
      end
    end

    module Filter
      extend ActiveSupport::Concern

      included do
        around_action do |controller, blk|
          ActiveDecorator::ViewContext.run_with(controller.view_context) do
            blk.call
          end
        end
      end
    end
  end
end
