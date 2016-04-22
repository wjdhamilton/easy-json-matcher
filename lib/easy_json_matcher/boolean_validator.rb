require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class BooleanValidator < Validator

    def _validate(candidate)
      errors << "#{candidate} is not a Boolean" unless _candidate_is_boolean?(candidate)
    end

    def _candidate_is_boolean?(candidate)
      clazz = candidate.class
      (clazz == TrueClass) || (clazz == FalseClass)
    end
  end
end
