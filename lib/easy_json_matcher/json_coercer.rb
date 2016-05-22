require "json"
require "easy_json_matcher/coercion_error"

module EasyJSONMatcher
  class JsonCoercer

    def coerce(json:)
      begin
        JSON.parse(json)
      rescue JSON::ParserError, TypeError
        raise CoercionError.new invalid_string: json
      end
    end
  end
end
