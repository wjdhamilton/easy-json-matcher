require 'test_helper'
require 'json'


class JsonapiMatcherTest < ActiveSupport::TestCase

  test "As a user I want to create new Schemas to match JSON objects" do
    # This test represents the minimum level of implementation required to create a
    # working node.
    test_schema = JSONAPIMatcher::SchemaGenerator.new { |schema|
      schema.contains_node(key: :data) do |node|
        node.has_attribute(key: :title, opts: {type: :string})
      end
    }.register(name: :test)

    valid_json = {
                     data: {
                          'title'=> "Here's a title"
                          }
                    }.to_json
    assert(test_schema.valid? valid_json)
  end


  test "As a user I want to be able to validate numbers" do

    test_schema = JSONAPIMatcher::SchemaGenerator.new {|schema|
      schema.has_attribute(key: :number, opts: {type: :number})
    }.generate_node

    valid_json = {
      number: 5.55,
    }.to_json

    assert(test_schema.valid?(valid_json), "Number was not validated")

    invalid_json = {
      number: "hi"
    }.to_json
    assert_not(test_schema.valid?(invalid_json), "\"hi\" should not have been valid")
  end

  test "As a user I want to be able to validate booleans" do

    test_schema = JSONAPIMatcher::SchemaGenerator.new {|schema|
      schema.has_attribute(key: :true, opts: {type: :boolean})
      schema.has_attribute(key: :false, opts: {type: :boolean})
    }.generate_node

    valid_json = {
      true: true,
      false: false
    }.to_json

    assert(test_schema.valid?(valid_json), "Boolean was not validated")

    invalid_json = {
      true: 1,
      false: "wibble"
    }

    assert_not(test_schema.valid?(invalid_json), "\"1\" and \"wibble\" are not valid boolean values")
  end

  test "As a user I want to be able to validate Array values" do
    test_schema = JSONAPIMatcher::SchemaGenerator.new {|schema|
      schema.has_attribute(key: :array, opts: {type: :array})
    }.generate_node

    valid_json = {
      array: []
    }.to_json

    assert(test_schema.valid?(valid_json), "Array was not validated")

    invalid_json = {
      array: 1
    }.to_json

    assert(!test_schema.valid?(invalid_json), "\"1\" is not a valid array value")
  end

  test "As a user I want to be able to specify what should be found in an array" do
    flunk "Implement me"
  end

  test "As a user I want to be able to validate date values" do
    test_schema = JSONAPIMatcher::SchemaGenerator.new { |schema|
      schema.has_attribute(key: :date, opts: {type: :date})
    }.generate_node

    valid_json = {
      date: "2015-01-15"
    }.to_json

    assert(test_schema.valid?(valid_json), "Date was not validated")

    invalid_json = {
      date: "Good night Mr. Tom"
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "\"Good night Mr. Tom\" should not have been validated as a date")
  end

  test "As a user I want to be able to use different types of date format" do
    flunk "Implement me"
  end

  test "As a user I want to be able to register a Schema so I can reuse it later" do

    JSONAPIMatcher::SchemaGenerator.new { |schema|
      schema.has_attribute(key: :ignore_me, opts: {type: :value})
    }.register(name: :test)

    assert(JSONAPIMatcher.available_schemas.include?(:test), ":test not found in available_nodes")
  end

  test "As a user I want to know why my json was not valid" do

    class Validator
      def valid?(json)
        raise JSONAPIMatcher::ValidationError.new ("Oops!!")
      end
    end

    test_schema = JSONAPIMatcher::SchemaGenerator.new { |schema|
      schema.has_attribute(key: :oops, opts: {type: :value})
      schema.contains_node(key: :nested_oops) do |node|
        node.has_attribute(key: :bigger_oops, opts: {type: :value})
      end
    }.generate_node

    # This JSON only reflects the structure of the above, it's validity is rendered
    # irrelevant by our monkey-patch of Validator
    valid_json = {
      oops: 'oops',
      nested_oops: {
        bigger_oops: 'bigger_oops'
      }
    }
    flunk "Implement me"

  end
end
