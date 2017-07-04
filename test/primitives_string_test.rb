require 'test_helper'
require 'json'

# This test suite covers the basic concept of validating that a value is a
# certain type

module EasyJSONMatcher

  describe "Primitive String Validation" do

    before do
      @test_schema = SchemaGenerator.new {
        has_string key: "string"
      }.generate_schema
    end

    it "should validate Strings" do
      candidate = { string: "hello" }.to_json
      @test_schema.validate(candidate: candidate).must_be :empty?
    end

    it "should return errors for non-strings" do
      candidate = { string: 1 }.to_json
      @test_schema.validate(candidate: candidate).wont_be :empty?
    end
  end
end
