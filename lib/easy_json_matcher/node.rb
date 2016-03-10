require 'easy_json_matcher'
require 'easy_json_matcher/validator_factory'
require 'json'
require 'easy_json_matcher/content_wrapper'
require 'forwardable'
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
      validity = true
      validators.each do |val|
        validity = false unless _use_validator val
      end
      validity
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

    def get_errors
      child_errors = _collect_child_errors
      _prep_errors(child_errors)
    end

    def _collect_child_errors
      validators.each_with_object({}) do |val, container|
        container.merge!(val.get_errors)
      end
    end

    def _prep_errors(child_errors)
      unless _is_root?
        errors_wrapper = {}
        errors_wrapper[key] = child_errors
        return errors_wrapper
      else
        return child_errors
      end
    end

    def _prep_candidate(json)
      if json.is_a? String
        _wrap_content(JSON.parse(json))
      else
        raise ArgumentError.new "Content for validation must be either a Hash or a String - you supplied #{json}, which is a #{json.class.name}" unless json.respond_to? :[]
        _wrap_content(json)
      end
    end

    def _wrap_content(json)
      ContentWrapper.new(json)
    end
  end
end
