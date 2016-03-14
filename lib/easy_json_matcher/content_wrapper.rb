module EasyJSONMatcher
  module ContentWrapper

    attr_reader :content

    def [](key)
      content[key.to_s]
    end

    def method_missing(method, *args, &block)
      content.send(method, *args, &block)
    end
  end
end
