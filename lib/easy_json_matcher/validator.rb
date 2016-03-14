module EasyJSONMatcher
  class Validator

    attr_reader :content, :required, :errors
    attr_accessor :key

    def initialize(options: {})
      @key = options[:key]
      @required = options[:required]
      @errors = []
    end

    def valid?(candidate)
      if key
        return false unless _check_content_type(candidate)
      end
      _set_content(candidate) #Hook
      if content.nil?
        # The algorithm has to stop here if content is nil, since subsequent
        # operations will assume that the content is present.
        return true unless _check_required?
      end
      _validate #Hook
      _no_errors?
    end

    #Hook
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

    # This method makees sure that the candidate is a json object, and not a
    # value or an array.
    def _check_content_type(candidate)
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

    def _no_errors?
      errors.empty?
    end
  end
end
