require "json"
require "easy_json_matcher/coercion_error"

module EasyJSONMatcher
  class JsonCoercer

    def coerce(json:)
      begin
        coerced = JSON.parse(json)
        symbolize_keys(hash: coerced)
      rescue JSON::ParserError
        raise CoercionError.new invalid_string: json
      end
    end

    def symbolize_keys(hash:)
      hash.keys.each do |key|
        value = hash.delete(key)
        convert_value(value)
        hash[key.to_sym] = value
      end
      hash
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
