require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Number Validation Step" do

  describe "should be able to return a instance that validates numbers" do

    it "the instance should not return any errors for a valid number" do
      require 'bigdecimal'
      (-10..10).step(0.01) do |n|
        n = BigDecimal.new(n,3).to_f
        assert_chain_verifies(type: :number, test_value: n, outcome: true ) 
      end
    end

    it "the instance should return errors for invalid numbers" do
      no_number = "hello"
      assert_chain_verifies(type: :number, test_value: no_number, outcome: false) 
    end
  end
end
