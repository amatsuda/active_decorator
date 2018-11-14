# frozen_string_literal: true

require 'active_decorator/view_context'
require 'rails'

module ActiveDecorator
  class Railtie < ::Rails::Railtie
    initializer 'active_decorator' do
      ActiveSupport.on_load :action_view do
        require 'active_decorator/monkey/action_view/partial_renderer'
        ActionView::PartialRenderer.send :prepend, ActiveDecorator::Monkey::ActionView::PartialRenderer
      end

      ActiveSupport.on_load :action_controller do
        require 'active_decorator/monkey/abstract_controller/rendering'
        ::ActionController::Base.send :prepend, ActiveDecorator::Monkey::AbstractController::Rendering

        require 'active_decorator/monkey/action_controller/base/rescue_from'
        ActionController::Base.send :prepend, ActiveDecorator::Monkey::ActionController::Base

        ActionController::Base.send :include, ActiveDecorator::ViewContext::Filter
      end

      if Rails::VERSION::MAJOR >= 5
        ActiveSupport.on_load :action_controller do
          if self == ActionController::API
            require 'active_decorator/monkey/abstract_controller/rendering'
            ::ActionController::API.send :prepend, ActiveDecorator::Monkey::AbstractController::Rendering

            require 'active_decorator/monkey/action_controller/base/rescue_from'
            ::ActionController::API.send :prepend, ActiveDecorator::Monkey::ActionController::Base
          end
        end
      end

      ActiveSupport.on_load :action_mailer do
        require 'active_decorator/monkey/abstract_controller/rendering'
        ActionMailer::Base.send :prepend, ActiveDecorator::Monkey::AbstractController::Rendering

        if ActionMailer::Base.respond_to? :before_action
          ActionMailer::Base.send :include, ActiveDecorator::ViewContext::Filter
        end
      end

      ActiveSupport.on_load :active_record do
        require 'active_decorator/monkey/active_record/associations'
        ActiveRecord::Associations::Association.send :prepend, ActiveDecorator::Monkey::ActiveRecord::Associations::Association
        if Rails.version.to_f < 5.1
          ActiveRecord::Associations::CollectionAssociation.send :prepend, ActiveDecorator::Monkey::ActiveRecord::Associations::CollectionAssociation
        end
        if Rails.version.to_f >= 4.0
          ActiveRecord::Associations::CollectionProxy.send :prepend, ActiveDecorator::Monkey::ActiveRecord::Associations::CollectionProxy
        end
      end
    end
  end
end
