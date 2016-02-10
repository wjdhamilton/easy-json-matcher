require 'easy_json_matcher'
require 'easy_json_matcher/validator_factory'
require 'json'
require 'easy_json_matcher/content_wrapper'
module EasyJSONMatcher
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
      @content = _is_root? ? candidate : candidate[key]
    end

    def _is_root?
      key.nil?
    end

    def _prep_candidate(json)
      if json.is_a? String
        wrap_content(JSON.parse(json))
      else
        raise "Content for validation must be either a Hash or a String - you supplied #{json}, which is a #{json.class.name}" unless json.respond_to? :[]
        wrap_content(json)
      end
    end

    def wrap_content(json)
      ContentWrapper.new(json)
    end
  end
end