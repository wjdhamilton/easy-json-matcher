require 'easy_json_matcher'

module EasyJSONMatcher
  class ValidatorSet

    attr_accessor :validators

    def initialize
      @validators = []
    end

    def add_validator(validator:, opts: {})
      copy = _copy_self
      copy.validators << validator
      copy
    end

    def <<(validator)
      if validator.is_a? Array
        copy = _copy_self
        copy.validators = copy.validators + validator 
        return copy
      else
        add_validator(validator: validator)
      end
    end

    def valid?(candidate)
      return true unless _validation_failed?(candidate)
    end

    def get_errors
      validators.each_with_object({}) {|val, errors| errors.merge!(val.get_errors)}
    end

    def _validation_failed?(candidate)
      validators.map {|val| val.valid?(candidate)}.include? false
    end

    def reset!
      validators.each(&:reset!)
    end

    def _copy_self
      copy = ValidatorSet.new
      copy.validators = validators.dup
      copy
    end
  end
end
