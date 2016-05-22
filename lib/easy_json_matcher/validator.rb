require 'easy_json_matcher/json_coercer'

module EasyJSONMatcher
  class Validator

    attr_reader :validation_chain, :coercer
    attr_accessor :key

    def initialize(validate_with:, coerce_with: JsonCoercer.new)
      @validation_chain = validate_with
      @coercer = coerce_with
    end

    # Hook. Allows further setup to be carried out by subclasses
    def _post_initialise(options); end

    def valid?(candidate:)
      errors = validate(candidate: candidate)
      errors.empty?
    end

    def validate(candidate:)
      candidate = coercer.coerce(json: candidate)
      validation_chain.call(value: candidate)
    end
  end
end
