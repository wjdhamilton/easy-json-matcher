require "easy_json_matcher/validator"
require "easy_json_matcher/array_content_validator"

module EasyJSONMatcher
  class ArrayValidator 

    attr_reader :verifier

    def initialize(opts: [], verify_content_as:, container: ArrayContentValidator, factory: ValidationChainFactory)
      chain = factory.get_chain(steps: verify_content_as)
      @verifier = factory.get_chain(steps: opts + [:array])
      @verifier.concat(container.new(verify_with: chain))
    end

    def call(value:)
      verifier.call(value: value)
    end
  end
end
