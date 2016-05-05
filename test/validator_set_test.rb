require 'test_helper'
require_relative '../lib/easy_json_matcher/validator_set.rb'
require "validator_interface_test"

class ValidatorSetTest < ActiveSupport::TestCase

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
    @subject.add_validator(key: :test, validator: test_val)
    assert(subject.validators.values.include?(test_val), 'test_val should be found in subject')
  end

  test "ValidatorSet#valid? should return true if all its validators validate
  their candidates" do
    mock_validators = {key1: mock_validator, key2: mock_validator }
    mock_validators.each_pair do |key, mock|
      @subject.add_validator(key: key, validator: mock)
    end
    assert(call_validate(candidate: { key1: "test", key2: "test" }))
  end

  test "ValidatorSet#valid? should return false if any of its validators find
  an invalid value" do
    mock_validators = { key1: mock_validator(validity: true), key2: mock_validator(validity: false) }
    mock_validators.each_pair do |key, mock|
     @subject.add_validator(key: key, validator: mock)
    end
   assert_not(call_validate(candidate: { key1: "test", key2: "test" }), "ValidatorSet should have returned false") 
  end

  test "ValidatorSet should return error messages in a hash" do
    @subject.add_validator(key: :invalid, validator: mock_validator)
    assert(@subject.validate({}).is_a?(Hash))
  end

  test "ValidatorSet should return the error messages for all its validators" do
    error_hash_a = mock_validator validity: false, error_message:  "a" 
    error_hash_b = mock_validator validity: false, error_message:  "b" 
    @subject.add_validator(key: :a, validator: error_hash_a)
    @subject.add_validator(key: :b, validator: error_hash_b)
    expected_error_message = { a: ["a"], b: ["b"] }
    assert_equal(expected_error_message, @subject.validate({})) 
  end

  def call_validate(candidate: {})
    subject.valid?(candidate)
  end

  def mock_validator(validity: true, error_message: nil)
    mock = MiniTest::Mock.new
    mock.expect(:valid?, validity,[Object])
    mock.expect(:validate, [error_message], [Object])
  end

end
