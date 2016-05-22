module EasyJSONMatcher
  class ArrayContentValidator

    attr_reader :next_step, :verifier

    def initialize(verify_with:)
      @verifier = verify_with
    end

    def call(value:)
      errors = []
      value.each do |val|
        errors += verifier.call(value: val)
      end
      errors
    end

    def >> (step)
      @next_step = step
    end
  end
end
