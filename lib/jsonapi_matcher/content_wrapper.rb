module JSONAPIMatcher
  class ContentWrapper

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def [](key)
      content[key.to_s]
    end

    def method_missing(method, *args)
      content.send(method, *args)
    end
  end
end
