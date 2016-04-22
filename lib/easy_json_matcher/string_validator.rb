require 'easy_json_matcher/validator'
module EasyJSONMatcher

  class StringValidator < Validator

    def _validate(candidate)
      # Could possible have a meta-method here that takes a list of symbols representing validator names
      # and executes them in the validator of self.
      _candidate_is_a_string?(candidate)
    end

    def _candidate_is_a_string?(candidate)
      errors << "#{candidate} is not a String" unless candidate.is_a? String
    end
  end
end
