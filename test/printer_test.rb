require "test_helper"

module EasyJSONMatcher
  describe Printer do

    it "should properly print a Schema" do
      schema = SchemaGenerator.new {
        string key: "val"
        contains_node key: "node" do
          string key: "inner_key"
          string key: "another_key"
          contains_node key: "another node" do
            string key: "inner_inner_key"
          end
        end
      }.generate_schema
      pr = Printer.new(node: schema)
      puts pr.inspect
      end
    end
end
