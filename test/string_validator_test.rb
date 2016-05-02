require "test_helper"
require "validator_interface_test"
require "check_type_validations"

class StringValidatorTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest
  extend CheckTypeValidations

  assert_validates_json_type(:string, EasyJSONMatcher::StringValidator)

  setup do
    @subject = EasyJSONMatcher::StringValidator.new
  end
end
