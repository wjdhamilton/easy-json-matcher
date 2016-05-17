require "easy_json_matcher/validator"
require "easy_json_matcher/array_content_validator"

module EasyJSONMatcher
  class ArrayValidator 

    attr_reader :verifier, :chain, :type_validator

    def initialize(opts: [], verify_content_as:, verifier: ArrayContentValidator, factory: ValidationChainFactory)
      @chain = factory.get_chain(of: verifier, steps: verify_content_as)
      @verifier = factory.get_chain(steps: opts + [:array])
      @verifier.concat(@chain)
    end

    def check(value:, errors: [])
      @verifier.check(value: value)
    end
  end
end
