require 'securerandom'
module EasyJSONMatcher
  class Validator

    attr_reader :content, :required
    attr_accessor :key

    def initialize(options: {})
      @key = options[:key]
      @required = options[:required]
    end

    def valid?(candidate)
      if key
        return false unless _check_content_type(candidate)
      end
      _set_content(candidate)
      if content.nil?
        return true unless _check_required?
      end
      _validate
    end

    # Hook
    def _set_content(candidate)
      @content = key ? candidate[key.to_s] : candidate
    end

    # This method makees sure that the candidate is a json object, and not a
    # value or an array.
    def _check_content_type(candidate)
      begin
        dummy_key = SecureRandom.hex(10)
        candidate[dummy_key]
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
