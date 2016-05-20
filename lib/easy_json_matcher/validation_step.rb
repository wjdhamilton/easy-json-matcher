# The ValidationStep class represents a step in the process of validating a value. Each ValidationStep
# instance can be chained to another ValidationStep instance in order to produce a defined process for 
# running validations within a given Validator. A use case for such a procedure is where a value is 
# required and of a certain type. In this case the validation for required must precede the check for 
# the type, and validation must cease if the value is nil. 
module EasyJSONMatcher
  class ValidationStep

    attr_reader :next_step, :verifier

    def initialize(verify_with:)
      @verifier = verify_with
    end

    def call(value:)
      errors = []
      if verifier.call(value, errors) == false || is_tail?
        errors
      else
        errors + next_step.call(value: value)
      end
    end

    def >>(step)
      @next_step = step
    end

    def concat(chain)
      is_tail? ? self.>>(chain) : next_step.concat(chain)
    end

    def is_tail?
      next_step.nil?
    end
  end
end
