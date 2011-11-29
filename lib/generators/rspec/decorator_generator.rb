module Rspec
  class DecoratorGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_spec_file
      empty_directory 'spec/decorators'

      template 'decorator_spec.rb', File.join('spec/decorators', "#{singular_name}_decorator_spec.rb")
    end
  end
end
