require 'easy_json_matcher/validator'

module EasyJSONMatcher

  class ObjectValidator < Validator

    attr_reader :keyset, :strict

    def _post_initialise(options)
      @keyset = options[:keyset]
    end

    def add_key(key)
      @keyset ||= []
      keyset << key
    end

    def _validate(candidate)
      _validate_content_type candidate
      _validate_keyset(candidate) if keyset
    end

    def _validate_content_type(candidate)
      _add_error("#{content} is not an Object") unless candidate.is_a? Hash
   end

    def _validate_keyset(candidate)
      _add_error("#{candidate.keys} does not match #{keyset}") unless candidate.keys.sort == keyset.sort
    end
  end
end

