module EasyJSONMatcher
  module ContentWrapper

    def [](key)
      content[key.to_s]
    end

    def method_missing(method, *args, &block)
      content.send(method, *args, &block)
    end

    def keys
      content.keys.map(&:to_sym)
    end
  end
end
