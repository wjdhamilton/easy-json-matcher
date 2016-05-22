module EasyJSONMatcher
  class ArrayValidator 
    include AutoInject.kwargs[:array_content_validator, :chain_factory]

    attr_reader :verifier

    def initialize(opts: [], verify_content_as:, **args)
      super
      chain = chain_factory.get_chain(steps: verify_content_as)
      @verifier = chain_factory.get_chain(steps: opts + [:array])
      @verifier.concat(array_content_validator.new(verify_with: chain))
    end

    def call(value:)
      verifier.call(value: value)
    end
  end
end
