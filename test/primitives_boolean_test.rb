require 'test_helper'
require 'json'

# This test suite covers the basic concept of validating that a value is a
# certain type

module EasyJSONMatcher

  describe "Basic Type Validations" do

    before do
      @test_schema = SchemaGenerator.new { |g|
        g.has_boolean key: "boolean"
      }.generate_schema
    end

    it "should validate booleans" do
      candidate = { boolean: true}.to_json
      @test_schema.validate(candidate: candidate).must_be :empty?
    end

    it "should return errors for non-booleans" do
      candidate = { boolean: 1 }.to_json
      @test_schema.validate(candidate: candidate).wont_be :empty?
    end
  end
end
