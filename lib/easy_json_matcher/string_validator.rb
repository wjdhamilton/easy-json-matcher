require 'easy_json_matcher/validator'
module EasyJSONMatcher

  class StringValidator < Validator

    def _validate
      # Could possible have a meta-method here that takes a list of symbols representing validator names
      # and executes them in the validator of self.
      _content_is_a_string?
    end

    def _content_is_a_string?
      errors << "#{content} is not a String" unless content.is_a? String
    end
  end
end
