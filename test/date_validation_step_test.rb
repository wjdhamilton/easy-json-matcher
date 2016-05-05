require "test_helper"
require "validation_chain_test_helper"

include ValidationChainTestHelper

describe "Date Validation Step" do

  describe "should be able to return a instance that validates dates" do

    it "should not return any errors for a valid ISO8601 date" do
      date = "2020-03-01"
      assert_chain_verifies(type: :date, test_value: date, outcome: true)
    end

    it "should return an error for an invalid date" do
      no_date = 1
      assert_chain_verifies(type: :date, test_value: no_date, outcome: false)
    end
  end
end
