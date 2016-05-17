module EasyJSONMatcher
  class ArrayContentValidator

    attr_reader :next_step, :verifier

    def initialize(verify_with:)
      @verifier = verify_with
    end

    def check(value:, errors: [])
      value.each do |val|
        break unless verifier.call(val, errors)
      end
      return next_step.check(value: value) if next_step or return errors
    end

    def >> (step)
      @next_step = step
    end
  end
end
