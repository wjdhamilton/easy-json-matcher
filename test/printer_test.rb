require "test_helper"

module EasyJSONMatcher
  describe Printer do

    it "should properly print a Schema" do
       byebug 
      skip "This test is currently checked using by printing to the console"
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
