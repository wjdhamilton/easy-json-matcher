require 'easy_json_matcher/validator'

module EasyJSONMatcher

  class ObjectValidator < Validator

    attr_reader :keyset, :strict

    def _post_initialise(options)
      @keyset = options[:keyset] || []
      @strict = options[:strict]
    end

    def add_key(key)
      new_keyset = [key] + keyset
      ObjectValidator.new(opts)
    end

    def _validate(candidate)
      _validate_content_type candidate
      _validate_keyset(candidate) if strict
    end

    def _validate_content_type(candidate)
      _add_error("#{content} is not an Object") unless candidate.is_a? Hash
   end

    def _validate_keyset
    end
  end
end

