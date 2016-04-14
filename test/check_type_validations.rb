module CheckTypeValidations

  KEY = :candidate
  
  TYPES = {
    number:   { KEY => 1 },
    string:   { KEY => "string" },
    boolean:  { KEY => true },
    object:   { KEY => {} },
    array:    { KEY => [] }
  }

  def assert_validates_json_type(name, validator)
    define_validates(name, validator)
    define_shouldnt_validate(name, validator)
  end

  def get_names
    TYPES.keys
  end

  def define_validates(name, validator)
    define_should_validate(name, validator)
  end

  def define_shouldnt_validate(name, validator)
    get_invalid_types(name).each {|type| define_should_not_validate(type, validator) }
  end

  def get_invalid_types(name)
    get_names - [name]
  end

  def check_type_is_json_value(name)
    raise "#{name} not a valid JSON type" unless names.include? name
  end

  def define_should_validate(type, validator)
    method_name = "test_#{validator}_should_validate_#{type}"
    define_method(method_name) do
      assert(@subject.valid?(TYPES[type]), "#{validator} did not validate #{type}")
    end
  end

  def define_should_not_validate(type, validator)
    method_name = "test_#{validator}_should_not_validate_#{type}"
    define_method(method_name) do
      assert_not(@subject.valid?(TYPES[type]), "#{validator} should not have validated #{type}")
    end
  end
end
