require "test_helper"
require "validator_interface_test"
require "check_type_validations"

class NumberValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:number, EasyJSONMatcher::NumberValidator)

  setup do
    @subject = EasyJSONMatcher::NumberValidator.new
  end
end
