# Asserts that a value is a double-precision floating point number in javascript format
require 'easy_json_matcher/validator'
module EasyJSONMatcher

  class NumberValidator < Validator

    def _validate(candidate)
      errors << "#{candidate} is not a Number" unless _candidate_is_a_number?(candidate)
    end

    def _candidate_is_a_number?(candidate)
      begin
        Kernel::Float(candidate)
        true
      rescue ArgumentError
        false
      rescue TypeError
        false
      end
    end
  end
end
