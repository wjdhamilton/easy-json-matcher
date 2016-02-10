# Asserts that a value is a double-precision floating point number in javascript format
require 'jsonapi_matcher/validator'
module JSONAPIMatcher
  class NumberValidator < Validator
    def _validate
      begin
        Kernel::Float(content)
        true
      rescue ArgumentError => e
        false
      end
    end

  end
end
