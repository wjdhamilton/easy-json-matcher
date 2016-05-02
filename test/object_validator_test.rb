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

  test "It should be validate an object that contains the correct keys" do
    subject = EasyJSONMatcher::ObjectValidator.new options: { keyset: [:a, :b, :c] }
    test_candidate = { a: 1, b: 2, c: 3 }
    assert subject.valid?(test_candidate), subject.errors
  end

  test "It should not validate an object that contains different keys" do
    subject = EasyJSONMatcher::ObjectValidator.new options: { keyset: [:a, :b, :c] }
    test_candidate = { d: 4, e: 5, f: 6}
    assert_not subject.valid?(test_candidate), "test_candidate should be invalid"
  end

  test "ObjectValidator#add_key should allow the user to add keys for validation" do
    keys = [:a, :b, :c]
    keys.each { |key| @subject.add_key(key) }
    test_candidate = { a: 1, b: 2, c: 3}
    assert @subject.valid? test_candidate
  end 
end
