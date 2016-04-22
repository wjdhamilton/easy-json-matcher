require "test_helper"
require "easy_json_matcher/object_validator"
require "validator_interface_test"
require "check_type_validations"

class ObjectValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:object, EasyJSONMatcher::ObjectValidator)

  setup do
    @subject = EasyJSONMatcher::ObjectValidator.new
  end

end
