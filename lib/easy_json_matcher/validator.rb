module EasyJSONMatcher
  class Validator

    attr_reader :content, :required, :errors, :custom_validator
    attr_accessor :key

    def initialize(options: {})
      @key = options[:key]
      @required = options[:required]
      @custom_validator = options[:custom_validator]
      @errors = []
      _post_initialise(options)
    end

    # Hook. Allows further setup to be carried out by subclasses
    def _post_initialise(options); end

    def valid?(candidate)
      if key
        return false unless _check_content_type(candidate)
      end
      _set_content(candidate) #Hook
      if content.nil?
         _check_required?
      else
        _validate #Hook
      end
      _run_custom_validator if custom_validator
      _no_errors?
    end

    # Hook. Overriden in Node
    def reset!
      errors.clear
    end

    # Hook
    # Protected method that Validators use to implement their validation logic.
    # Called by #valid?
    def _validate
      raise NotImplementedError.new "Validators must override _validate"
    end

    # Hook
    # Protected method that Validators use to set their content from the candidate.
    def _set_content(candidate)
      @content = key ? candidate[key] : candidate
    end

    # Hook.
    # This method returns the errors that this validator has found in the candidate.
    def get_errors
      error_message = {}
      # Should the method just add errors even if there has been no error? Would
      # avoid undefined method [] for nil:NilClass if you look for a key where
      # there is no error but it would also make the output harder to read...
      error_message[key.to_sym] = errors
      error_message
    end

    # This method makees sure that the candidate behaves like a Hash, and not a
    # value or an array.
    def _check_content_type(candidate)
      # TODO perhaps this should raise an error instead of returning false?
      # if the value that has arrived at this point doesn't behave like a Hash then it
      # is in the wrong place.
      begin
        candidate[key]
      rescue TypeError
        return false
      end
      true
    end

    def _check_required?
      if required
        errors << "Value was not present"
        return true
      else
        return false
      end
    end

    def _create_validator(type:, opts: {})
      ValidatorFactory.get_instance(type: type, opts: opts)
    end

    def _custom_validator?
      custom_validator
    end

    def _run_custom_validator
      if error_message = custom_validator.call(content)
        errors << error_message
      end
    end

    def _no_errors?
      errors.empty?
    end
  end
end
