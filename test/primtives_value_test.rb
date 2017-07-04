require 'test_helper'
require 'json'

# This test suite covers the basic concept of validating that a value is a
# certain type

module EasyJSONMatcher

  describe "Value primitive test" do

    before do
      @test_schema = SchemaGenerator.new {
        has_boolean key: :value
      }.generate_schema
    end

    it "should validate any explicitly set value" do
      candidate = { value: nil}.to_json
      @test_schema.validate(candidate: candidate).must_be :empty?
    end

  end
end
