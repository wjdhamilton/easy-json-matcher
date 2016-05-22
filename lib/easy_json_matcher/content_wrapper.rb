module EasyJSONMatcher
  module ContentWrapper

    attr_reader :content

    def [](key)
      content[key.to_s]
    end

    def keys
      content.keys.map(&:to_sym)
    end
  end
end
