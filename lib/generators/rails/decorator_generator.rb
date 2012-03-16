module Rails
  module Generators
    class DecoratorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      desc <<DESC
Description:
    Stubs out a decorator module in app/decorators directory.

Examples:
    `rails g decorator book`

    This creates:
        app/decorators/book_decorator.rb
DESC

      def create_decorator_file
        template 'decorator.rb', File.join('app/decorators', "#{singular_name}_decorator.rb")
      end

      hook_for :test_framework
    end
  end
end
