require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ArrayValidator 
    attr_reader :validators, :validator_results, :errors

    def initialize
      @errors = []
    end
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
      _add_validator(create_validator(type: type, opts: opts))
    end

######################## Private methods #######################################

    def valid?(candidate_array)
      errors << "#{candidate_array} is not an Array" unless candidate_is_array? candidate_array
      _validate_array(candidate_array)
    end

    def validate(candidate_array)
      []
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

    def create_validator(type:, opts:)
      ValidatorFactory.get_instance(type: type, opts: opts)
    end

    def _add_validator(validator)
      validators << validator
    end

    def validators
      @validators ||= []
    end

    def _accumulate_errors(validator, array)
      array.each do |candidate|
        errors << validator.validate(candidate)
      end
    end

    def _run_validator(validator, candidate)
      validator.valid? candidate
    end

    def _validation_result
      !validator_results.include? false
    end
  end
end
