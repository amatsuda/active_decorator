module ActiveDecorator
  def self.configure(&block)
    yield @config ||= ActiveDecorator::Configuration.new
  end

  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :decorator_suffix
  end

  configure do |config|
    config.decorator_suffix = 'Decorator'
  end
end
