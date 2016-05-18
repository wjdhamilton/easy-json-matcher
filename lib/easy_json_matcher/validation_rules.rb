module EasyJSONMatcher

  VALIDATION_RULES = {
    object: -> (value, errors) {
    unless value.is_a? Hash
      errors << "#{value} is not an Object"
      return false
    end
  },
    string: -> (value, errors) {
    unless value.is_a? String
      errors << "#{value} is not a String"
      return false
    end
  },
    number: -> (value, errors){
    error_message = "#{value} is not a Number"
    begin
      Kernel::Float(value)
    rescue ArgumentError, TypeError
      errors << error_message
      false
    end
  },
    date: ->(value, errors){
    require "date"
    error_message = "#{value} is not a valid SQL date"
    begin
      Date.strptime(value,"%Y-%m-%d")
    rescue ArgumentError, TypeError
      errors << error_message
    end
  },
    boolean: ->(value, errors){
    clazz = value.class
    unless (clazz == TrueClass) || (clazz == FalseClass)
      errors << "#{value} is not a Boolean"
      false
    end
  },
    array: ->(value, errors){
    unless value.is_a? Array
      errors << "Value was not an array"
      false
    end
  },
    value: ->(value, errors){
    # This is a bit of a toughie since value can be any value, including nil
  },
    not_required: ->(value, errors){
    false if value.nil?
  },
    required: ->(value, errors){
      errors << "no value found" and return false if value.nil?
  }
  }
end


