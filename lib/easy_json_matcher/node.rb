require "easy_json_matcher/validation_step"

module EasyJSONMatcher
  class Node 
    extend Forwardable

    attr_reader :node_validator, :validators

    def_delegator :@validators, :add_validator

    #TODO should really use dependency injection here for ValidatorSet. 

    def initialize(validator:)
      @node_validator = validator
      @validators = ValidatorSet.new
    end

    def check(value:, errors:[])
      node_validator >> validators
      node_validator.check(value: value, errors: errors)
    end
  end
end
