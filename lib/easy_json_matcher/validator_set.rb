require 'easy_json_matcher'

module EasyJSONMatcher
  class ValidatorSet

    attr_accessor :validators

    def initialize
      @validators = {}
    end

    def add_validator(key:, validator:, opts: {})
      validators[key] = validator
    end

    def check(value:, errors:[])
      errors << validators.each_with_object({}) do |k_v, errors_found|
        key = k_v[0]
        val = value[key]
        validator = k_v[1]
        errors_found[key] = validator.check(value: val)
      end
    end
  end
end
