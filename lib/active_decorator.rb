begin
  require 'rails'
rescue LoadError
  #do nothing
end

require 'active_decorator/version'
require 'active_decorator/decorator'

if defined? Rails
  require 'active_decorator/railtie'
end
