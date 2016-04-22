module CheckTypeValidations

  KEY = :candidate

  TYPES = {
    number:    1 ,
    string:    "string" ,
    boolean:   true ,
    object:    {} ,
    array:     [] 
  }

  def assert_validates_json_type(name, validator)
    if name == :value
      handle_value_edge_case 
    else
      assert_validates(name, validator)
      assert_shouldnt_validate(name, validator)
    end
  end

  def handle_value_edge_case
    # The thing is, that value can be anything, including nil so all the above 
    # values should return true since they are all values. 
  end

  def get_names
    TYPES.keys
  end

  def assert_validates(name, validator)
    assert_should_validate(name, validator)
  end

  def assert_shouldnt_validate(name, validator)
    get_invalid_types(name).each {|type| assert_should_not_validate(type, validator) }
  end

  def get_invalid_types(name)
    get_names - [name]
  end

  def check_type_is_json_value(name)
    raise "#{name} not a valid JSON type" unless names.include? name
  end

  def assert_should_validate(type, validator)
    method_name = "test_#{validator}_should_validate_#{type}"
    define_method(method_name) do
      assert(@subject.valid?(TYPES[type]), "#{validator} did not validate #{type}")
    end
  end

  def assert_should_not_validate(type, validator)
    method_name = "test_#{validator}_should_not_validate_#{type}"
    define_method(method_name) do
      assert_not(@subject.valid?(TYPES[type]), "#{validator} should not have validated #{type}")
    end
  end
end
