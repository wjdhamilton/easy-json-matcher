require "easy_json_matcher/validation_step"

module EasyJSONMatcher
  class Node 

    attr_reader :node_validator, :validators

    def initialize(opts: [], strict: false, validators:, content_handler: ValidatorSet, factory: ValidationChainFactory)
      @node_validator = factory.get_chain(steps: opts + [:object])
      @validators = content_handler.new(validators: validators, strict: strict)
      @node_validator.concat(@validators)
    end

    def call(value:)
      node_validator.call(value: value)
    end
  end
end
