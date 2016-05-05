require "easy_json_matcher/easy_json_matcher_error"

module EasyJSONMatcher
  class CoercionError < EasyJSONMatcherError

    def initialize(invalid_string:)
      super "#{invalid_string} is not a valid json string"
    end
  end
end
