# frozen_string_literal: true
module Rails
  module Generators
    class DecoratorGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_decorator_file
        template 'decorator.rb', File.join('app/decorators', class_path, "#{file_name}_decorator.rb")
      end

      hook_for :test_framework
    end
  end
end
