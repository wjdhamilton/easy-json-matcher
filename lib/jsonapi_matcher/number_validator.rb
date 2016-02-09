require 'jsonapi_matcher/validator'
# Asserts that a value is a double-precision floating point number in javascript format
module JSONAPIMatcher
  class NumberValidator < Validator
    def _validate
      begin
        Kernel::Float(json)
        true
      rescue ArgumentError => e
        false
      end
    end

  end
end
