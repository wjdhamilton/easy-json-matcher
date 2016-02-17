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

  test "It can validate JSON Schema payloads" do
    EasyJSONMatcher::SchemaGenerator.new { |country|
      country.has_attribute key: :id,      opts: {type: :number, required: true}
      country.contains_node(key: :attributes) do |atts|
        atts.has_attribute key: :alpha_2,  opts: {type: :string, required: true}
        atts.has_attribute key: :alpha_3,  opts: {type: :string, required: true}
        atts.has_attribute key: :name,     opts: {type: :string, required: true}
      end
    }.register(schema_name: :country)

    EasyJSONMatcher::SchemaGenerator.new {|country_payload|
      country_payload.contains_schema(schema_name: :country, opts: {key: :data})
    }.register(schema_name: :country_payload)

    valid_json = "{\"data\":{\"id\":\"4376\",\"type\":\"countries\",\"attributes\":{\"alpha_2\":\"GB\",\"alpha_3\":\"GBR\",\"name\":\"United Kingdom of Great Britain and Northern Ireland\"}}}"

    validator = EasyJSONMatcher::SchemaLibrary.get_schema(:country_payload)
    assert(validator.valid? valid_json)
  end
end
