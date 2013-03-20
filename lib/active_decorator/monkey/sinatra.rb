module Sinatra
  class Base
    set :decorators, Proc.new { root && File.join(root, 'decorators') }
    set :protected_instance_variables,
      ActiveDecorator::Sinatra::DEFAULT_PROTECTED_INSTANCE_VARIABLES
    
    before do
      ActiveDecorator::ViewContext.current = self
    end
  end
  module Templates
    def render_with_decorate(engine, data, options = {}, locals = {}, &block)
      locals = options.delete(:locals) || locals || {}
      locals.values.each do |v|
        ActiveDecorator::Decorator.instance.decorate v
      end

      scope = options.delete(:scope) || self
      ivars = scope.instance_variable_names - settings.protected_instance_variables
      ivars.each do |n|
        ActiveDecorator::Decorator.instance.decorate scope.instance_variable_get(n)
      end
      options[:scope] = scope

      render_without_decorate(engine, data, options, locals, &block)
    end
    alias_method_chain :render, :decorate
  end
end
