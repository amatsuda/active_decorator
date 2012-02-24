require 'active_decorator/view_context'
require 'rails'

module ActiveDecorator
  class Railtie < ::Rails::Railtie
    initializer 'active_decorator' do
      ActiveSupport.on_load(:action_view) do
        require 'active_decorator/monkey/action_view/partial_renderer'
      end
      ActiveSupport.on_load(:action_controller) do
        require 'active_decorator/monkey/abstract_controller/rendering'
        ActionController::Base.send :include, ActiveDecorator::ViewContext::Filter
      end
      ActiveSupport.on_load(:action_mailer) do
        require 'active_decorator/monkey/abstract_controller/rendering'
      end
    end
  end
end
