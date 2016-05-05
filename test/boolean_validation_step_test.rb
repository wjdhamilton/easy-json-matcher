require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Boolean Validation Step" do

  describe "should be able to return an instance that validates booleans" do

    it "should not return any errors for a boolean" do
      [true,false].each { |b| assert_chain_verifies(type: :boolean, test_value: b, outcome: true)}
    end

    it "should return an error for an invalid boolean" do
      no_bool = 0
      assert_chain_verifies(type: :boolean, test_value: no_bool, outcome: false)
    end
  end
end
