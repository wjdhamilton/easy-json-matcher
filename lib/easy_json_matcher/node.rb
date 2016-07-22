require "easy_json_matcher/validation_step"

module EasyJSONMatcher
  class Node 
    include AutoInject.kwargs[:node_content_validator, :chain_factory]

    attr_reader :node_validator, :validators

    def initialize(opts: [], strict: false, validators:, **args)
      super(**args)
      @node_validator = chain_factory.get_chain(steps: opts + [:object])
      @validators = node_content_validator.new(validators: validators, strict: strict)
      @node_validator.concat(@validators)
    end

    def call(value:)
      node_validator.call(value: value)
    end
  end
end
