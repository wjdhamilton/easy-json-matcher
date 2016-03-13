require 'easy_json_matcher/validator'
module EasyJSONMatcher

  class StringValidator < Validator

    def _validate
      # Could possible have a meta-method here that takes a list of symbols representing validator names
      # and executes them in the validator of self.
      _valid_type?
    end

    def _explain_errors
      errors << "#{content} is not a String" unless _valid_type?
    end

    def _valid_type?
      content.is_a? String
    end
  end
end
