require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ObjectValidator < Validator
    def _validate
      _content_is_object?
    end

    def _content_is_object?
      errors << "#{content} is not an object" unless content.is_a? Hash
    end
  end
end
