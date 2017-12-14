module EasyJSONMatcher
  # Override of Ruby error for namespacing
  class Error < RuntimeError; end


  class UnknownValidationStepError < Error

    def error_message (type)
      "No validator available for #{type}, 
       you have either asked to validate a type that is not supported
       or a schema that has not been defined. If it is the 
       former, consider using a custom validator"
    end

    def initialize(type)
      super error_message(type)
    end
  end
end
