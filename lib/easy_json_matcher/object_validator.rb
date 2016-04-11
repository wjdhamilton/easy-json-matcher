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

    def _validate
      _validate_content_type
      _validate_keyset if strict
    end

    def _validate_content_type
      _add_error("#{content} is not an Object") unless _content_is_object?
    end

    def _content_is_object?
      content.is_a? Hash
    end

    def _validate_keyset
    end
  end
end

