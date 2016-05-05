module EasyJSONMatcher
  class Validator

    attr_reader :validation_chain, :required, :errors, :custom_validator, :opts
    attr_accessor :key

    def initialize(options: {})
      @validation_chain = options[:validate_with]
    end

    # Hook. Allows further setup to be carried out by subclasses
    def _post_initialise(options); end

    def valid?(candidate:)
      errors = validate(candidate: candidate)
      errors.empty?
    end

    def validate(candidate:)
      validation_chain.check(value: candidate)
    end
  end
end
