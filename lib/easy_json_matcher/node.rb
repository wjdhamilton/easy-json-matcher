require "easy_json_matcher/validation_step"

module EasyJSONMatcher
  class Node 
    extend Forwardable

    attr_reader :node_validator, :validators

    def_delegator :@validators, :add_validator

    def initialize(opts: [], strict: false, content_handler: ValidatorSet, factory: ValidationChainFactory)
      @node_validator = factory.get_chain(steps: opts + [:object])
      @validators = content_handler.new
      @node_validator.concat(@validators)
    end

    def check(value:, errors:[])
      node_validator >> validators
      node_validator.check(value: value, errors: errors)
    end
  end
end
