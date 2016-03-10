require 'easy_json_matcher/validator'
module EasyJSONMatcher

  class StringValidator < Validator

    def _validate
      unless content.is_a? String
        errors << "#{content} is not a String"
        false
      else
        true
      end
    end
  end
end
