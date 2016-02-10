require 'jsonapi_matcher'
require 'jsonapi_matcher/validator_factory'
require 'json'
module JSONAPIMatcher
  class Node < Validator
    extend Forwardable

    attr_reader :validators

    def_delegators :content, :[]

    def initialize(opts: {})
      super(options: opts)
      @validators = []
    end

    def add_validator(validator)
      validators << validator
    end

    def _validate
      validators.each do |val|
        return false unless _use_validator val
      end
      true
    end

    def _use_validator(validator)
      validator.valid? self
    end

    def _get_content_for(key)
      content[key.to_s]
    end

    def _get_validator_for(key)
      validators[key]
    end

    def _set_content(candidate)
      candidate = _prep_candidate(candidate)
      @content = _is_root? ? candidate : candidate[key.to_s]
    end

    def _is_root?
      key.nil?
    end

    def _prep_candidate(json)
      if json.is_a? String
        JSON.parse(json)
      else
        raise "Content for validation must be either a Hash or a String - you supplied #{json}, which is a #{json.class.name}" unless json.respond_to? :[]
        json
      end
    end
  end
end
