require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Object validation step" do

    describe "should be able to return an instance that validates objects" do

      it "the instance should not return any errors for a valid object" do
        test_value = JSON.parse({}.to_json) # Yes, I know this is odd
        assert_chain_verifies(type: :object, test_value: test_value, outcome: true)
      end

      it "the instance should return errors for an invalid object" do
        no_object = String.new
        assert_chain_verifies(type: :object, test_value: no_object, outcome: false)
      end
    end
end
