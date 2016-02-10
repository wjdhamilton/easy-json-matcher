require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ArrayValidator < Validator
    def _validate
      content.is_a? Array
    end
  end
end
