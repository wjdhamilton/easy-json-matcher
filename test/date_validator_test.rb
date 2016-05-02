require "test_helper"
require "validator_interface_test"
require "check_type_validations"

class DateValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:date, EasyJSONMatcher::DateValidator)

  setup do
    @subject = EasyJSONMatcher::DateValidator.new
  end
end
