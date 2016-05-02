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
      @errors = {}
    end

    def _default_validator
      ObjectValidator.new(options: { key: key })
    end

    def add_validator(key:, validator:)
      validators.add_validator(key: key, validator: validator)
      node_validator.add_key(key) if strict
    end

    def valid?(candidate)
      return false unless candidate.is_a? Hash
      _validate_strict_keyset(candidate)
      _find_errors(candidate)
      _no_errors?
    end

    def _find_errors(candidate)
      errors.merge!(validators.get_errors) unless validators.valid? candidate
    end

    def _no_errors?
      errors.empty?
    end

    def reset!
      errors.clear
      validators.reset!
    end

    def _validate_strict_keyset(candidate)
      errors[:node_errors] = node_validator.get_errors unless node_validator.valid?(candidate)
    end

    def get_errors
      errors
    end
  end
end
