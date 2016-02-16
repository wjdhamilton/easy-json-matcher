module EasyJSONMatcher
  class Validator

    attr_reader :content, :required
    attr_accessor :key

    def initialize(options: {})
      @key = options[:key]
      @required = options[:required]
    end

    def valid?(candidate)
      _set_content(candidate)
      if content.nil?
        return true unless _check_required?
      end
      _validate
    end

    def _set_content(candidate)
      @content = key ? candidate[key.to_s] : candidate
    end

    def _check_required?
      required
    end
  end
end
