require "test_helper"
require "easy_json_matcher/exceptions"

module EasyJSONMatcher
  class ManagingSchemasTest < ActiveSupport::TestCase

    setup do
      @name = :test
      sc = SchemaGenerator.new { 
        has_attribute(key: "name", opts: [ :string, :required ])
      }
      sc.register(as: @name)
    end

    test "As a user I want to be able to register a Schema so I can reuse it later" do
      assert(SchemaLibrary.available_schemas.include?(:test), ":test not found in available_nodes")
    end

    test "The order in which schemas are defined should not matter" do
      test_schema = SchemaGenerator.new { 
        has_schema key: "lazy", name: :lazily_evaluated
      }.register as: :outer

      SchemaGenerator.new {
        has_attribute key: "val"
      }.register as: :lazily_evaluated

      valid_json = {
        lazy: {
          val: 1
        }
      }.to_json

      assert test_schema.valid?(candidate: valid_json)
    end

    test "As as user I want to reuse a saved schema"  do
      candidate = {
        name: "Green Mandarin"
      }.to_json
      schema = SchemaLibrary.use_schema(name: @name)
      assert(schema.valid?(candidate: candidate), "test_schema did not validate correctly")
    end

    test "SchemaLibrary should thrown a UnknownValidationStepError if an unregistered schema is requested" do
      schema = SchemaLibrary.get_schema(name: "#{@name.to_s}-wibble")
      assert_raises(UnknownValidationStepError) do
        schema.call(value: {}.to_json)
      end
    end

    test "SchemaLibrary should tell the user which schema is missing" do
      schema = SchemaLibrary.get_schema(name: :womble)
      begin
        schema.call(value: {}.to_json)
      rescue UnknownValidationStepError => ex
        assert ex.message =~ /womble/
      end
    end

    test "As a user I want to reuse a schema within another schema" do
      test_schema = SchemaGenerator.new {
        has_boolean key: "is_present", opts: [ :required ]
        has_schema key: :test, name: :test
      }.generate_schema

      invalid_json = {
        is_present: true,
      }

      valid_json = invalid_json.dup
      valid_json.store(@name, {name: "Achilles Tang"})
      valid_json = valid_json.to_json
      assert(test_schema.valid?(candidate: valid_json), "Stored schema did not validate correctly")
    end

    test "It can validate JSON Schema payloads" do
      SchemaGenerator.new { 
        has_attribute key: "id", opts: [:number, :required]
        contains_node(key: "attributes") do |node|
          node.has_attribute key: "alpha_2",  opts: [ :string, :required ]
          node.has_attribute key: "alpha_3",  opts: [ :string, :required ]
          node.has_attribute key: "name",     opts: [ :string, :required ]
        end
      }.register(as: :country)

      country_payload = SchemaGenerator.new {
        has_schema(key: "data", name: :country)
      }.register(as: :country_payload)

      valid_json = "{\"data\":{\"id\":\"4376\",\"type\":\"countries\",\"attributes\":{\"alpha_2\":\"GB\",\"alpha_3\":\"GBR\",\"name\":\"United Kingdom of Great Britain and Northern Ireland\"}}}"

      assert country_payload.valid?(candidate: valid_json)
    end
  end
end
