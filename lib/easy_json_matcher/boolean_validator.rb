require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class BooleanValidator < Validator
    def _validate
      clazz = content.class
      (clazz == TrueClass) || (clazz == FalseClass)
    end
  end
end
