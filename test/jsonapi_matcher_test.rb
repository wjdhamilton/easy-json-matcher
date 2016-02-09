require 'test_helper'
require 'json'


class JsonapiMatcherTest < ActiveSupport::TestCase

  test "As a user I want to create new Schemas to match JSON objects" do
    # This test represents the minimum level of implementation required to create a
    # working node.
    test_schema = JSONAPIMatcher::SchemaGenerator.new { |schema|
      schema.contains_node(key: :data) do |node|
        node.with_attribute(key: :title, opts: {type: :string})
      end
    }.register(name: :test)

    matching_json = {
                     data: {
                          'title'=> "Here's a title"
                          }
                    }.to_json
    assert(JSONAPIMatcher.available_schemas.include?(:test), ":test not found in available_nodes")
    assert(JSONAPIMatcher.schema_for(:test).valid? matching_json)
    assert(test_schema.valid? matching_json)
  end

  test "As a user I want to be able to validate different data types" do

    test_schema = JSONAPIMatcher::SchemaGenerator.new {|schema|
      schema.with_attribute(key: :string, opts: {type: :string})
      schema.with_attribute(key: :number, opts: {type: :number})
      schema.with_attribute(key: :boolean, opts: {type: :boolean})
      schema.with_attribute(key: :array, opts: {type: :array})
      schema.with_attribute(key: :date, opts: {type: :date})
      schema.with_attribute(key: :value, opts: {type: :value})
    }.generate_node

    matching_json = {
      string: "hello",
      number: 5,
      boolean: true,
      array: [],
      date: '1978-01-15',
      value: nil
    }.to_json

    assert(test_schema.valid? matching_json)
  end
end
