require 'easy_json_matcher'

module EasyJSONMatcher
  class ValidatorSet

    attr_accessor :validators, :strict

    def initialize(validators:, strict: false)
      @validators = validators
      @strict = strict
    end

    def call(value:)
      error_hash = validators.each_with_object({}) do |k_v, errors_found|
        key = k_v[0]
        val = value[key.to_s]
        validator = k_v[1]
        results = validator.call(value: val)
        errors_found[key] = results unless results.empty?
      end
      validate_strict_keyset(keys: validators.keys, candidates: value.keys, errors: error_hash) if strict
      errors = []
      errors << error_hash unless error_hash.empty?
      errors
    end

    def validate_strict_keyset(keys:, errors:, candidates:)
      missing_keys(keys: keys, errors: errors, candidates: candidates)
      unexpected_keys(keys: keys, errors: errors, candidates: candidates)
    end

    def missing_keys(keys:, errors:, candidates:)
      missing = keys - candidates
      errors[:missing_keys] = "Missing keys: #{missing}" unless missing.empty?
    end

    def unexpected_keys(keys:, errors:, candidates:)
      rogue_keys = candidates - keys
      errors[:unexpected_keys] = "Unexpected keys: #{rogue_keys}" unless rogue_keys.empty?
    end

    def to_s
      validators.to_s
    end
  end
end
