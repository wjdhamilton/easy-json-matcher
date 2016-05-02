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

    def valid?(candidate)
      return true unless _validation_failed?(candidate)
    end

    def get_errors
      validators.each_with_object({}) {|val, errors| errors[val[0]] = val[1].get_errors}
    end

    def _validation_failed?(candidate)
      validators.map {|k,v|
        v.valid?(candidate[k])
      }.include? false
    end

    def reset!
      validators.values.each(&:reset!)
    end
  end
end
