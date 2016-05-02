require 'easy_json_matcher/validator_factory'
require 'json'
require 'easy_json_matcher/content_wrapper'

module EasyJSONMatcher
  class Node 
    include ContentWrapper

    attr_reader :validators, :strict, :errors, :node_validator
    attr_accessor :key

    def initialize(opts: {})
      @key = opts[:key]
      @strict = opts[:strict]
      @validators = ValidatorSet.new
      @node_validator = opts[:validate_with] || _default_validator
      @options = opts
      @errors = []
    end

    def _default_validator
      ObjectValidator.new(options: { key: key })
    end

   def add_validator(key:, validator:)
      validators.add_validator(key: key, validator: validator)
      node_validator.add_key(key) if strict
    end

    def valid?(candidate)
      candidate = _set_content(candidate)
      if _no_errors?
        _validate_strict_keyset(candidate)
        _find_errors(candidate)
      end
      _no_errors?
    end

    def _find_errors(candidate)
      errors << validators.get_errors unless validators.valid? candidate
    end

    def _no_errors?
      errors.empty?
    end

    def reset!
      errors.clear
      validators.reset!
    end

    def _validate_strict_keyset(candidate)
      errors << node_validator.get_errors unless node_validator.valid?(candidate)
    end

    def _validate_keyset
      unexpected_keys = keys - _expected_keys
      errors << "#{unexpected_keys} found in addition to expected keys" unless unexpected_keys.empty?
    end

    def _expected_keys
      # Horrible hacky thing to be sorted soon
      validators.validators.each_with_object([]) do |validator, keyset|
        keyset << validator.key
      end
    end

    def _set_content(candidate)
      _is_root? ? _prep_root_content(candidate) : candidate[key]
    end

    def _is_root?
      key.nil?
    end

    def get_errors
      child_errors = _collect_child_errors
      _wrap_errors(child_errors)
    end

    def _collect_child_errors
      validators.get_errors
    end

    def _wrap_errors(child_errors)
      _add_local_errors_to child_errors
      unless _is_root?
        _wrap_child_errors(child_errors)
      else
        _root_errors(child_errors)
      end
    end

    def _add_local_errors_to(child_errors)
      child_errors.merge!({node_errors_: errors}) unless errors.empty?
    end

    def _wrap_child_errors(child_errors)
      errors_wrapper = {}
      errors_wrapper[key] = child_errors
      errors_wrapper
    end

    def _root_errors(child_errors)
      errors.length > 0 ? {root: errors}.merge(child_errors) : child_errors
    end

    def _prep_root_content(candidate)
       candidate.is_a?(String) ? _parse_and_verify_json(candidate) : candidate
    end

    def _parse_and_verify_json(json)
      begin
        candidate = JSON.parse(json)
        symbolize_keys hash: candidate
      rescue JSON::ParserError
        errors << '#{json} is not a valid JSON String'
      end
    end

    def symbolize_keys(hash:)
      hash.keys.each do |key|
        value = hash.delete(key)
        symbolize_keys(hash: value) if value.is_a? Hash
        hash[key.to_sym] = value
      end
      hash
    end
  end
end
