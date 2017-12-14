module EasyJSONMatcher
  class Validator
    include AutoInject.kwargs[:coercer]

    attr_reader :validation_chain, :coercer
    attr_accessor :key

    def initialize(validate_with:, **args)
      super(**args)
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

    def to_s
      "#{key.to_s} : #{validation_chain.to_s}"
    end
  end
end
