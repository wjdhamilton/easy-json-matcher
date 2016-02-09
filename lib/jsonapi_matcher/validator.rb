module JSONAPIMatcher
  class Validator

    attr_reader :json

    def initialize(opts)
    end

    def valid?(candidate)
      @json = candidate
      _validate
    end
  end
end
