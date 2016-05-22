require "json"
require "easy_json_matcher/coercion_error"

module EasyJSONMatcher
  class JsonCoercer

    def coerce(json:)
      begin
        coerced = JSON.parse(json)
      rescue JSON::ParserError, TypeError
        raise CoercionError.new invalid_string: json
      end
    end

    def convert_value(value)
      case value
      when Hash
        symbolize_keys(hash: value) if value.is_a? Hash
      when Array
        value.select {|val| val.is_a? Hash}.each {|h| symbolize_keys(hash: h) }
      end
    end
  end
end
