require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "String Validation Chain" do

  describe "should be able to retun an instance that validates strings" do

    it "the instance should not return any errors for a valid string" do
      string = String.new
      assert_chain_verifies(type: :string, test_value: string, outcome: true)
    end

    it "the instance should return errors if the value is not a string" do
      no_string = 1
      assert_chain_verifies(type: :string, test_value: no_string, outcome: false)
    end
  end
end
