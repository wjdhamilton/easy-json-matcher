require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Required Validation Step" do

  describe ":required option" do

    it "should not return any errors if the value is present" do
      present = 1
      assert_chain_verifies type: :required, test_value: present, outcome: true
    end

    it "should return an error if a value is not present" do
      [nil].each { |v| assert_chain_verifies type: :required, test_value: v, outcome: false }
    end
  end
end
