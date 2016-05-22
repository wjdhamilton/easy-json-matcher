
require 'test_helper'
require 'json'

# This test suite covers the basic concept of validating that a value is a
# certain type

module EasyJSONMatcher

  describe "Date primitive" do

    before do
      @test_schema = SchemaGenerator.new { |g|
        g.has_date key: "date"
      }.generate_schema
    end

    it "should validate dates" do
      candidate = { date: "2015-04-01"}.to_json
      @test_schema.validate(candidate: candidate).must_be :empty?
    end

    it "should return errors for non-dates" do
      candidate = { date: "hello" }.to_json
      @test_schema.validate(candidate: candidate).wont_be :empty?
    end
  end
end
