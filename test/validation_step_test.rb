require "test_helper"
require "easy_json_matcher/validation_step"

module EasyJSONMatcher

  class ValidationStepTest < ActiveSupport::TestCase

    setup do
      @subject = ValidationStep.new(verify_with: ->(value, errors) {} )
    end

    test "it_should_respond_to_call" do
      assert_respond_to(@subject, :call)
    end

    test "It should allow the user to chain validation steps together" do
      head = @subject
      tail = MiniTest::Mock.new
      test_value = "hello!"
      head >> tail
      tail.expect(:call, [], [Hash])
      tail.expect(:nil?, false)
      head.call(value: test_value)
      tail.verify
    end

    test "It should send call to the verifier assigned to it" do
      verifier = MiniTest::Mock.new
      subject = ValidationStep.new(verify_with: verifier)
      test_value = "verify me"
      verifier.expect(:call, nil, [test_value, []])
      subject.call(value: test_value)
    end

    test "If the verifier returns :stop the chain will be halted" do
      verifier = ->(value, errors) { false }
      middle = ValidationStep.new(verify_with: verifier)
      tail = MiniTest::Mock.new
      test_value = "verify me"
      @subject >> middle >> tail
      @subject.call(value: test_value)
      # There is no official way to call that something wasn't called in
      # MiniTest, so we'll just have to assume that since verify passes, then
      # call wasn't called in tail
      tail.verify
    end

    test "It should return an array of errors found" do
      head = ValidationStep.new(verify_with: ->(value, errors) { errors << 1 })
      tail = ValidationStep.new(verify_with: ->(value, errors) { errors << 2 })
      head >> tail
      assert(head.call(value: "Oh! Mrs. Mogs") == [1, 2])
    end
  end
end
