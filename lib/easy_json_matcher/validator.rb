module EasyJSONMatcher
  class Validator
    include AutoInject.kwargs[:coercer]

    attr_reader :validation_chain
    attr_accessor :key

    def initialize(validate_with:, **args)
      super
      @validation_chain = validate_with
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
