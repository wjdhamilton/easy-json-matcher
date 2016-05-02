require "easy_json_matcher"
require "json"

module EasyJSONMatcher
  class RootAdapter

    attr_reader :node, :errors

    def initialize(node:, opts:{})
      @node = node
      @errors = []
    end

    def valid? candidate
      candidate = coerce candidate
      node.valid? candidate if errors.empty? or false
    end

    def get_errors
      error_hash = {}
      error_hash[:root] = errors unless errors.empty?
      error_hash.merge(node.get_errors)
    end

    def coerce(candidate)
      begin
        coerced = JSON.parse(candidate)
        symbolize_keys(hash: coerced)
      rescue JSON::ParserError
        errors << "#{candidate} is not a valid JSON String"
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
