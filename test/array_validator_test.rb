require "test_helper"
require "validator_interface_test"
require "check_type_validations"

class BooleanValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:array, EasyJSONMatcher::ArrayValidator)

  setup do
    @subject = EasyJSONMatcher::ArrayValidator.new
  end
end
