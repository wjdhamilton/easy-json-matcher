
require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Required Validation Step" do

  describe "should validate the presence of a value" do

    it "the instance should not return any errors if a value is present" do
      test_value = 1
      assert_chain_verifies(type: :required, test_value: test_value, outcome: true ) 
      end

    it "the instance should return errors for invalid numbers" do
      missing = nil
      assert_chain_verifies(type: :required, test_value: missing, outcome: false) 
    end
  end
end
