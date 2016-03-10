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
        return true unless _check_required?
      end
      _validate
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
      @content = key ? candidate[key.to_s] : candidate
    end

    # Hook.
    # This method returns the errors that this validator has found in the candidate.
    def get_errors
      error_message = {}
      if errors.length > 0
        error_message[key] = errors
      end
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
      required
    end

    def _create_validator(type:, opts: {})
      ValidatorFactory.get_instance(type: type, opts: opts)
    end
  end
end
