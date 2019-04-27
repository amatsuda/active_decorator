# frozen_string_literal: true

require 'active_decorator/version'
require 'active_decorator/decorator'
begin
  require 'rails'
  require 'active_decorator/railtie'
rescue LoadError
end
require 'active_decorator/config'
