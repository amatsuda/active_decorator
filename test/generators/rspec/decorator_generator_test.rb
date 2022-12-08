# frozen_string_literal: true

require 'test_helper'
require 'rails/generators'
require 'generators/rspec/decorator_generator'

class DecoratorGeneratorTest < Rails::Generators::TestCase
  tests Rspec::Generators::DecoratorGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test 'generator runs without errors' do
    assert_nothing_raised do
      run_generator ['decorator']
    end
  end
end
