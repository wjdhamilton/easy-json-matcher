require "test_helper"
require "easy_json_matcher/validator_set.rb"

module EasyJSONMatcher

  describe ValidatorSet do

    it "should hold other validators" do
      test_val = Object.new
      subject = ValidatorSet.new validators: { test:  test_val }
      subject.validators.values.include?(test_val).must_be :==, true
    end

    it "should return true if all its validators validate their candidates" do
      mock_validators = { key1: mock_validator, key2: mock_validator }
      subject = ValidatorSet.new validators: mock_validators
      subject.check(value: {}).must_be :empty?
    end

    it "should return false if any of its validators find an invalid value" do
      mock_validators = { 
        key1: mock_validator(validity: true), 
        key2: mock_validator(validity: false)
      }
      subject = ValidatorSet.new validators: mock_validators
      subject.check(value: { key1: "test", key2: "test" }).wont_be :empty?
    end

    it "should return error messages in a Array" do
      subject = ValidatorSet.new validators: { invalid: mock_validator }
      assert(subject.check(value: {}).is_a?(Array))
    end

    it "should return the error messages for all its validators" do
      error_validators = {
        a: mock_validator(validity: false, error_message:  "a"),
        b: mock_validator(validity: false, error_message:  "b")
      }
      subject = ValidatorSet.new(validators: error_validators)
      expected_error_message = [{ a: ["a"], b: ["b"] }]
      assert_equal(expected_error_message, subject.check(value: {}))
    end

    def mock_validator(validity: true, error_message: nil)
      mock = MiniTest::Mock.new
      mock.expect(:check, validity ? [] : [error_message], [Object])
    end
  end
end
