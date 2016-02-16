require 'test_helper'

class ManagingSchemasTest < ActiveSupport::TestCase

  setup do
    @name = :test
    EasyJSONMatcher::SchemaGenerator.new { |schema|
      schema.has_attribute(key: :name, opts: {type: :string, required: true})
    }.register(schema_name: @name)
  end

  test "As a user I want to be able to register a Schema so I can reuse it later" do
    assert(EasyJSONMatcher::SchemaLibrary.available_schemas.include?(:test), ":test not found in available_nodes")
  end

  test "As as user I want to reuse a saved schema"  do
    test_schema = {
      name: 'Green Mandarin'
    }.to_json

    schema = EasyJSONMatcher::SchemaLibrary.get_schema(@name)
    assert(schema.valid?(test_schema), "test_schema did not validate correctly")
  end

  test "SchemaLibrary should thrown a MissingSchemaException if an unregistered schema is requested" do
    assert_raises(EasyJSONMatcher::MissingSchemaException) do
      EasyJSONMatcher::SchemaLibrary.get_schema("#{@name.to_s}-wibble")
    end
  end

  test "As a user I want to reuse a schema within another schema" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new { |s|
      s.has_attribute(key: :is_present, opts: {type: :boolean, required: true})
      s.contains_schema(schema_name: @name)
    }.generate_node

    invalid_json = {
      is_present: true,
    }

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have been valid as it does not include the saved schema")

    valid_json = invalid_json.dup
    valid_json.store(@name, {name: 'Achilles Tang'})
    valid_json = valid_json.to_json
    assert(test_schema.valid?(valid_json), "Stored schema did not validate correctly")
  end
end
