require 'sinatra/base'
require 'active_decorator'
require 'active_decorator/view_context'
require 'active_support/core_ext/object'

module ActiveDecorator
  module Sinatra
    DEFAULT_PROTECTED_INSTANCE_VARIABLES = %w[
      @app @default_layout @env @params @preferred_extension
      @request @response @template_cache
    ].freeze

    class << self
      def registered(app)
        app.class_eval do
          Dir[File.join(settings.decorators, '**/*_decorator.rb')].each do |path|
            require path
          end
        end
      end

      alias included registered
    end
  end
end

require 'active_decorator/monkey/sinatra'
