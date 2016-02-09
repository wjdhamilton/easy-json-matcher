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
      @content = _prep_candidate(json)
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

    def _prep_candidate(json)
      if json.is_a? String
        JSON.parse(json)
      else
        raise "Content for validation must be either a Hash or a String - you supplied #{json}, which is a #{json.class.name}" unless json.is_a? Hash
        json
      end
    end

    def _valid_attribute?(key)
      for_validation = _get_content_for key
      validator = validators[key]
      _use_validator(validator, for_validation)
    end

    def _use_validator(validator, json)
      validator.valid? json
    end

    def _get_content_for(key)
      content[key.to_s]
    end

    def _get_validator_for(key)
      validators[key]
    end
  end
end
