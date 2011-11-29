module TestUnit
  class DecoratorGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_test_file
      empty_directory 'test/decorators'

      template 'decorator_test.rb', File.join('test/decorators', "#{singular_name}_decorator_test.rb")
    end
  end
end
