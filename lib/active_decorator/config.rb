# frozen_string_literal: true

module ActiveDecorator
  def self.config
    @_config ||= Struct.new(:decorator_suffix).new
  end

  def self.configure
    yield config
  end

  config.decorator_suffix = 'Decorator'
end
