require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class BooleanValidator < Validator

    def _validate
      _content_is_boolean?
    end

    def _content_is_boolean?
      clazz = content.class
      (clazz == TrueClass) || (clazz == FalseClass)
    end

    def _explain_errors
      errors << "#{content} is not a Boolean" unless _content_is_boolean?
    end
  end
end
