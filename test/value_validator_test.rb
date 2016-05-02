require "test_helper"
require "validator_interface_test"
require "check_type_validations"

class ValueValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:value, EasyJSONMatcher::ValueValidator)

  setup do
    @subject = EasyJSONMatcher::ValueValidator.new
  end
end
