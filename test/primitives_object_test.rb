require 'test_helper'
require 'json'

# This test suite covers the basic concept of validating that a value is a
# certain type

module EasyJSONMatcher

  describe "Object primitive test" do

    before do
      @test_schema = SchemaGenerator.new {
        has_object key: "object"
      }.generate_schema
    end

    it "should validate booleans" do
      candidate = { object: { a: 1}}.to_json
      @test_schema.validate(candidate: candidate).must_be :empty?
    end

    it "should return errors for non-booleans" do
      candidate = { object: 1 }.to_json
      @test_schema.validate(candidate: candidate).wont_be :empty?
    end
  end
end
