
module EasyJSONMatcher
  class EasyJSONMatcherError < RuntimeError

    def initialize(error_details)
      super(error_details)
    end
  end
end
