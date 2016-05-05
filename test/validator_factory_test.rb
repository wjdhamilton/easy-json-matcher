require "test_helper"
require "easy_json_matcher/validator_factory"

describe EasyJSONMatcher::ValidatorFactory do

  describe "standard validators" do

    it "should create an object validator" do
      validator = create_validator(type: :object)
      test_value = JSON.parse({}.to_json) # Yes, I know this is weird but JSON parsing is not handled by the Validator. 
      validator.valid?(test_value).must_be :==, true
    end

    it "should create a string validator" do
      validator = create_validator(type: :string)
      test_value = "Hello"
      validator.valid?(test_value).must_be :==, true
    end

    it "should create a number validator" do
      validator = create_validator(type: :number)
      test_value = 1
      validator.valid?(test_value).must_be :==, true
    end

    it "should create a date validator" do
      validator = create_validator(type: :date)
      test_value = Date.today.to_s
      validator.valid?(test_value).must_be :==, true
    end
      
  end

  def create_validator(type:)
    EasyJSONMatcher::ValidatorFactory.get_instance(type: type)
  end
end
