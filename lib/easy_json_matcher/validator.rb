module EasyJSONMatcher
  class Validator

    attr_reader :content, :key, :required

    def initialize(options: {})
      @key = options[:key]
      @required = options[:required]
    end

    def valid?(candidate)
      _set_content(candidate)
      return false unless _check_required
      _validate
    end

    def _set_content(candidate)
      @content = key ? candidate[key.to_s] : candidate
    end

    def _check_required
      return true unless required
      byebug
      return true if content
    end
  end
end
