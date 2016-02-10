module JSONAPIMatcher
  class Validator

    attr_reader :content
    attr_reader :key

    def initialize(options: {})
      @key = options[:key]
    end

    def valid?(candidate)
      _set_content(candidate)
      _validate
    end

    def _set_content(candidate)
      @content = key ? candidate[key.to_s] : candidate
    end

    def _access_content(key)
      key = key.to_s
      content[key]
    end

  end
end
