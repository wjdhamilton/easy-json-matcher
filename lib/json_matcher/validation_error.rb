module JSONAPIMatcher
  class ValidationError < Error

    def initialize(error_details)
      super(error_details)
    end
  end
end
