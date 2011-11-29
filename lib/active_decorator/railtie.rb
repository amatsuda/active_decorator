require 'rails'

module ActiveDecorator
  class Railtie < ::Rails::Railtie
    initializer 'active_decorator' do
      ActiveSupport.on_load(:action_view) do
        require 'monkey/action_view/partial_renderer'
      end
      ActiveSupport.on_load(:action_controller) do
        require 'monkey/abstract_controller/rendering'
      end
      ActiveSupport.on_load(:action_mailer) do
        require 'monkey/abstract_controller/rendering'
      end
    end
  end
end
