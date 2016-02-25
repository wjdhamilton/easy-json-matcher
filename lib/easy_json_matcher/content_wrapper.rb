module EasyJSONMatcher
  class ContentWrapper

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def [](key)
      content[key.to_s]
    end

    def method_missing(method, *args, &block)
      content.send(method, *args, &block)
    end
  end
end
