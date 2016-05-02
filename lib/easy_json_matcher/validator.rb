module EasyJSONMatcher
  class Validator

    attr_reader :content, :required, :errors, :custom_validator, :opts
    attr_accessor :key

    def initialize(options: {})
      @required = options[:required]
      @custom_validator = options[:custom_validator]
      @opts = options
      @errors = []
      _post_initialise(options)
    end

    # Hook. Allows further setup to be carried out by subclasses
    def _post_initialise(options); end

    def valid?(candidate)
      if candidate.nil?
         _check_required?
      else
        _validate candidate #Hook
      end
      _run_custom_validator(candidate) if custom_validator
      _no_errors?
    end

    # Hook
    # Protected method that Validators use to implement their validation logic.
    # Called by #valid?
    def _validate(candidate)
      raise NotImplementedError.new "Validators must override _validate"
    end

    # Hook.
    # This method returns the errors that this validator has found in the candidate.
    def get_errors
      errors
    end

    def _check_required?
      if required
        errors << "Value was not present"
        return false
      else
        return true
      end
    end

    def _create_validator(type:, opts: {})
      ValidatorFactory.get_instance(type: type, opts: opts)
    end

    def _custom_validator?
      custom_validator
    end

    def _run_custom_validator(candidate)
      if error_message = custom_validator.call(candidate)
        errors << error_message
      end
    end

    # Add an error to the list of errors to be returned
    def _add_error(error)
      errors << error
    end

    def _no_errors?
      errors.empty?
    end

    def reset!
      errors.clear
    end
  end
end
