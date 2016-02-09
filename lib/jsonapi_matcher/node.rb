require 'jsonapi_matcher'
require 'jsonapi_matcher/validator_factory'
require 'json'
module JSONAPIMatcher
  class Node

    attr_reader :validators
    attr_reader :content

    def initialize(opts: {})
      @validators = {}
    end

    def valid?(json)
      @content = JSON.parse(json)
      attributes_valid?
    end

    def add_validator_for(key:, validator:)
      validators[key] = validator
    end

    def attributes_valid?
      validators.keys.each do |key|
        return false unless _valid_attribute? key
      end
      true
    end

    def _valid_attribute?(key)
      for_validation = content[key]
      validator = validators[key]
      _use_validator(validator, for_validation)
    end

    def _use_validator(validator, json)
      byebug
      validator.valid? json
    end
  end
end
