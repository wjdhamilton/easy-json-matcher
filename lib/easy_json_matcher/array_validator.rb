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

    def _validate(candidate_array)
      errors << "#{candidate_array} is not an Array" unless candidate_is_array? candidate_array
      _validate_array(candidate_array)
    end

    def candidate_is_array?(candidate)
      candidate.is_a? Array
    end

    def _validate_array(array)
      validators.each do |val|
        _accumulate_errors val, array
      end
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

    def _accumulate_errors(validator, array)
      array.each do |candidate|
        _run_validator(validator, candidate)
      end
      errors << validator.errors unless validator._no_errors?
    end

    def _run_validator(validator, candidate)
      validator.valid? candidate
    end

    def _validation_result
      !validator_results.include? false
    end
  end
end
