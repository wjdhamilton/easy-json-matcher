require 'easy_json_matcher/validator_factory'
require 'json'
require 'easy_json_matcher/content_wrapper'
module EasyJSONMatcher
  class Node < Validator
    include ContentWrapper

    attr_reader :validators, :validity, :strict

    def initialize(opts: {})
      super(options: opts)
      @validators = []
      @validity = true
    end

    def add_validator(validator)
      validators << validator
    end

    def _post_initialise(options)
      @strict = options[:strict]
    end

    def _validate
      _validate_strict_keyset
      validators.each do |val|
        @validity = false unless _use_validator val
      end
    end

    def _validate_strict_keyset
      _validate_keyset if strict
    end

    def _validate_keyset
      unexpected_keys = keys - _expected_keys
      errors << "#{unexpected_keys} found in addition to expected keys" unless unexpected_keys.empty?
    end

    def _expected_keys
      validators.each_with_object([]) do |validator, keyset|
        keyset << validator.key
      end
    end

    def _use_validator(validator)
      validator.valid? self
    end

    def _get_content_for(key)
      content[key]
    end

    def _get_validator_for(key)
      validators[key]
    end

    def _set_content(candidate)
      @content = _is_root? ? _prep_root_content(candidate) : candidate[key]
    end

    def _is_root?
      key.nil?
    end

    def get_errors
      child_errors = _collect_child_errors
      _wrap_errors(child_errors)
    end

    def _collect_child_errors
      validators.each_with_object({}) do |val, container|
        container.merge!(val.get_errors)
      end
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
      errors.length > 0 ? {root: errors} : child_errors
    end

    def _prep_root_content(candidate)
       candidate.is_a?(String) ? _parse_and_verify_json(candidate) : candidate
    end

    def _parse_and_verify_json(json)
      begin
        JSON.parse(json)
      rescue JSON::ParserError
        errors << '#{json} is not a valid JSON String'
      end
    end

    def _no_errors?
      validity && errors.empty?
    end
  end
end
