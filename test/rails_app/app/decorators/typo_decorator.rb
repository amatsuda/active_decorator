# frozen_string_literal: true

# decorator that raises NameError while being loaded, to test that the error is not swallowed
module TypoDecorator
  include NonExistentHelper
end
