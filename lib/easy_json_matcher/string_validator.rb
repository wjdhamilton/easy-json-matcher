require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class StringValidator < Validator

  def _validate
    content.is_a? String
  end

  end
end
