require 'test_helper'
require_relative '../lib/easy_json_matcher/validator_set.rb'
require "validator_interface_test"

class ValidatorSetTest < ActiveSupport::TestCase
  include ValidatorInterfaceTest

  attr_reader :subject
  class ValidatorDouble

    def valid?(value)
      true
    end
  end

  setup do
    @subject = EasyJSONMatcher::ValidatorSet.new
  end

  test "ValidatorSet should hold other validators" do
    test_val = ValidatorDouble.new
    @subject = add_validator(validator: test_val)
    assert(subject.validators.include?(test_val), 'test_val should be found in subject')
  end

  test "ValidatorSet should call valid? on all its validators" do
    mock_validators = [mock_validator, mock_validator]
    mock_validators.each do |mock|
      @subject = add_validator(validator: mock)
    end
    call_validate
    mock_validators.each(&:verify)
  end

  test "ValidatorSet#valid? should return true if all its validators validate
  their candidates" do
    mock_validators = [mock_validator, mock_validator]
    mock_validators.each do |mock|
      @subject = add_validator(validator: mock)
    end
    assert(call_validate)
  end

  test "ValidatorSet#valid? should return false if any of its validators find
  an invalid value" do
    mock_validators = [mock_validator(validity: true), mock_validator(validity: false)]
    mock_validators.each do |mock|
     @subject = add_validator(validator: mock)
    end
   assert_not(call_validate, "ValidatorSet should have returned false") 
  end

  test "ValidatorSet#add_validator should return a ValidatorSet instance" do
    new_val = add_validator validator: ValidatorDouble.new
    assert new_val.is_a?(EasyJSONMatcher::ValidatorSet)
  end

  test "ValidatorSet should return a new instance of itself whenever a new
  validator is added" do
    validator = ValidatorDouble.new
    copy = add_validator(validator: validator)
    assert_not(copy === subject, "Copy should have been a new instance of validator")
  end

  test "ValidatorSet should return error messages in a hash" do
    @subject = add_validator(validator: mock_with_errors)
    assert(@subject.get_errors.is_a?(Hash))
  end

  test "ValidatorSet should return the error messages for all its validators" do
    error_hash_a = mock_with_errors error_message: { a: "a" }
    error_hash_b = mock_with_errors error_message: { b: "b" }
    @subject = @subject.add_validator(validator: error_hash_a).add_validator(validator: error_hash_b)
    expected_error_message = { a: "a", b: "b" }
    assert_equal(expected_error_message, @subject.get_errors) 
  end

  test "ValidatorSet#<< should allow the user to add a single validator" do
    test_validator = ValidatorDouble.new
    @subject = subject << test_validator
    assert(subject.validators.include? test_validator)
  end

  test "ValidatorSet#<< should allow the user to add multiple validators" do
    test_validator = ValidatorDouble.new
    @subject = subject << test_validator
    validators = [ValidatorDouble.new, ValidatorDouble.new]
    @subject = subject << validators
    assert(subject.validators == (validators.unshift(test_validator)))
  end

  test "Validator should handle the unwrapping of values" do
    value = "a string"
    test_candidate = { candidate: value}
    test_validator = MiniTest::Mock.new
    test_validator.expect(:valid?, true, [value])
    @subject = subject.add_validator(validator: test_validator)
    call_validate(test_candidate)
    test_validator.verify
  end
  
  def mock_with_errors(error_message: { mock: "error message" })
    validator = MiniTest::Mock.new
    validator.expect(:get_errors, error_message)
    validator
  end

  def call_validate(candidate: {})
    subject.valid?(candidate: candidate)
  end

  def add_validator(validator:)
    subject.add_validator(validator: validator)
  end

  def mock_validator(validity: true)
    mock = MiniTest::Mock.new
    mock.expect(:valid?, validity, [Hash])
  end

end
