require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

module EasyJSONMatcher

  describe "Not Required Validation Step" do

    describe "should halt the chain if the value is missing" do

      it "should halt the chain if the value is missing" do
        head, tail = get_validation_chain
        test_value = nil
        head.check(value: test_value).must_be :empty?
      end

      it "should allow the chain to continue if the value is present" do
        head, tail = get_validation_chain
        test_value = 1
        tail.expect(:check, [], [{ value: 1 }])
        tail.expect(:nil?, false)
        head.check(value: test_value)
        tail.verify
      end
    end

    def get_validation_chain
      head = ValidationChainFactory.get_step_for validating: :not_required
      tail = Minitest::Mock.new
      head >> tail
      return head, tail
    end
  end
end
