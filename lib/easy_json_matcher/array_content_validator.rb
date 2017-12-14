module EasyJSONMatcher
  class ArrayContentValidator

    attr_reader :verifier

    def initialize(verify_with:)
      @verifier = verify_with
    end

    def call(value:)
      errors = []
      value.each do |val|
        # TODO: You could remove the duplication of array content errors here
        errors += verifier.call(value: val)
      end
      errors
    end
  end
end
