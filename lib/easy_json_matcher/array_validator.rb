require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ArrayValidator < Validator
    attr_reader :validators, :validator_results
######################### Methods for requiring values by type #################

    def should_only_contain_strings(opts: {})
      should_only_contain type: :string, opts: opts
    end

    def should_only_contain_objects(opts: {})
      should_only_contain type: :object, opts: opts
    end

    def should_only_contain_values(opts: {})
      should_only_contain type: :value, opts: opts
    end

    def should_only_contain_numbers(opts: {})
      should_only_contain type: :number, opts: opts
    end

    def should_only_contain_booleans(opts: {})
      should_only_contain type: :boolean, opts: opts
    end

    def should_only_contain_dates(opts: {})
      should_only_contain type: :date, opts: opts
    end

    def should_only_contain_schema(name:, opts: {})
      should_only_contain type: :schema, opts: opts.merge({name: name})
    end

    def should_only_contain(type:,opts: {})
      _clear_validators
      _add_validator(_create_validator(type: type, opts: opts))
    end

######################## Private methods #######################################

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

    def _define_errors
      errors << "#{content} is not an Array" unless _content_is_array?
    end
  end
end
