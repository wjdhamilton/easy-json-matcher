require "test_helper"

module EasyJSONMatcher

  describe "Shortened Names" do

    it "should allow the user to require attributes wihout has_" do
      schema = EasyJSONMatcher::SchemaGenerator.new do |sc|
        sc.boolean key: "bool"
        sc.number  key: "num"
        sc.date    key: "date"
        sc.object  key: "object"
        sc.value   key: "val"
        sc.string  key: "string"
      end.generate_schema

      valid = {
        bool: true,
        num: 1,
        date: "2015-01-15",
        object: {},
        value: nil,
        string: "hello"
      }.to_json

      schema.valid?(candidate: valid).must_be :==, true
    end
  end
end
