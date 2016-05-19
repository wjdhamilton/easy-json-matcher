require "easy_json_matcher/easy_json_matcher_error"

module EasyJSONMatcher
  class UnknownValidationStepError < EasyJSONMatcherError

    def initialize(type)
      super "No validator available for #{type}, consider using a custom validator"
    end
  end
end
