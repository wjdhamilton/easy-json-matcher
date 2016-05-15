require 'easy_json_matcher'

module EasyJSONMatcher
  class ValidatorSet

    attr_accessor :validators

    def initialize
      @validators = {}
    end

    def add_validator(key:, validator:)
      validators[key] = validator
    end

    def check(value:, errors:[])
      error_hash = validators.each_with_object({}) do |k_v, errors_found|
        key = k_v[0]
        val = value[key]
        validator = k_v[1]
        results = validator.check(value: val)
        errors_found[key] = results unless results.empty?
      end
      errors << error_hash unless error_hash.empty?
      errors
    end
  end
end
