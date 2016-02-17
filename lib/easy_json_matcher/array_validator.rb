require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ArrayValidator < Validator
    attr_reader :validators, :validator_results

    def _validate
      return false unless _content_is_array?
      _validate_content
    end

    def _content_is_array?
      content.is_a? Array
    end

    def _validate_content
      validators.each do |val|
        _run_validator(val)
      end
      _validation_result
    end

    def should_only_contain(type:,opts: {})
      _clear_validators
      _add_validator(_create_validator(type: type, opts: opts))
    end

    def _clear_validators
      validators.clear
    end

    def _add_validator(validator)
      validators << validator
    end

    def validators
      @validators ||= []
    end

    def _run_validator(v)
      content.each do |value|
        validator_results << v.valid?(value)
      end
    end

    def _validation_result
      !validator_results.include? false
    end

    def validator_results
      @validator_results ||= []
    end
  end
end
