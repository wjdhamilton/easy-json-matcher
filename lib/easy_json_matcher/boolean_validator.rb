require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class BooleanValidator < Validator

    def _validate
      errors << "#{content} is not a Boolean" unless _content_is_boolean?
    end

    def _content_is_boolean?
      clazz = content.class
      (clazz == TrueClass) || (clazz == FalseClass)
    end
  end
end
