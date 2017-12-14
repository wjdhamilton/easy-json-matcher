module EasyJSONMatcher

  class ValidationRule

    attr_reader :rule, :type

    def initialize(type, rule)
      @type = type
      @rule = rule
    end

    def call(value, errors)
      rule.call(value, errors)
    end
  end


  VALIDATION_RULES = {
    object: ValidationRule.new(:object, -> (value, errors) {
      unless value.is_a? Hash
        errors << "#{value} is not an Object"
        return false
      end
    }),

    string: ValidationRule.new(:string, -> (value, errors) {
      unless value.is_a? String
        errors << "#{value} is not a String"
        return false
      end
    }),

    number: ValidationRule.new(:number, -> (value, errors){
      error_message = "#{value} is not a Number"
      begin
        Kernel::Float(value)
      rescue ArgumentError, TypeError
        errors << error_message
        false
      end
    }),

    date: ValidationRule.new(:date, ->(value, errors){
      require "date"
      error_message = "#{value} is not a valid SQL date"
      begin
        Date.strptime(value,"%Y-%m-%d")
      rescue ArgumentError, TypeError
        errors << error_message
      end
    }),

    boolean: ValidationRule.new(:boolean, ->(value, errors){
      clazz = value.class
      unless [ TrueClass, FalseClass].include? clazz
        errors << "#{value} is not a Boolean"
        false
      end
    }),

    array: ValidationRule.new(:array, ->(value, errors){
      unless value.is_a? Array
        errors << "Value was not an array"
        false
      end
    }),

    value: ValidationRule.new(:value, ->(value, errors){
      # This is a bit of a toughie since value can be any value, including nil
    }),

    not_required: ValidationRule.new(:not_required, ->(value, errors){
      false if value.nil?
    }),

    required: ValidationRule.new(:required, ->(value, errors){
      errors << "no value found" and return false if value.nil?
    })
  }
end


