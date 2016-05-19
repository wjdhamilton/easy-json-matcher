require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Value Validation Step" do

  describe "should be able to return an instance that verifies values" do

    it "should not return any errors for a valid value, which includes nil" do
      value = nil
      assert_chain_verifies type: :value, test_value: value, outcome: true 
    end
  end
end
