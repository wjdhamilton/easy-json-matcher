require 'test_helper'
require 'json'


class JsonapiMatcherTest < ActiveSupport::TestCase

  test "As a user I want to create new Schemas to match JSON objects" do
    # This test represents the minimum level of implementation required to create a
    # working node.
    test_schema = EasyJSONMatcher::SchemaGenerator.new { |schema|
      schema.contains_node(key: :data) do |node|
        node.has_attribute(key: :title, opts: {type: :string})
      end
    }.register(schema_name: :test)

    valid_json = {
                   data: {
                        'title'=> "here's a title"
                        }
                  }.to_json
    assert(test_schema.valid? valid_json)
  end


  test "As a user I want to be able to validate numbers" do

    test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
      schema.has_number(key: :number, opts: {required: :true})
    }.generate_node

    valid_json = {
      number: 5.55,
    }.to_json

    assert(test_schema.valid?(valid_json), "Number was not validated")

    invalid_json = {
      number: "hi"
    }.to_json
    assert_not(test_schema.valid?(invalid_json), "\"hi\" should not have been valid")

    invalid_nil = {
      number: nil
    }.to_json
    assert_not(test_schema.valid?(invalid_nil), "#{invalid_nil} should not have validated, or thrown an error")
  end

  test "As a user I want to be able to validate booleans" do

    test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
      schema.has_boolean(key: :true)
      schema.has_boolean(key: :false)
    }.generate_node

    valid_json = {
      true: true,
      false: false
    }.to_json

    assert(test_schema.valid?(valid_json), "Boolean was not validated")

    invalid_json = {
      true: 1,
      false: "wibble"
    }.to_json

    # byebug
    assert_not(test_schema.valid?(invalid_json), "\"1\" and \"wibble\" are not valid boolean values")
  end

  test "As a user I want to be able to validate Array values" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
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

  test "As a user I want to be able to validate date values" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new { |schema|
      schema.has_date(key: :date)
    }.generate_node

    valid_json = {
      date: "2015-01-15"
    }.to_json

    assert(test_schema.valid?(valid_json), "Date was not validated")

    not_a_date = 'Good Night Mr. Tom'
    invalid_json = {
      date: not_a_date
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "\"#{not_a_date}\" should not have been validated as a date")
  end

  test "As a user I want to be able to use different types of date format" do
    flunk "Implement me"
  end

  test "As a user I want to validate object values" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new { |schema|
      schema.has_object(key: :object)
    }.generate_node

    is_an_object = {}

    valid_json = {
      object: is_an_object
    }.to_json

    assert(test_schema.valid?(valid_json),"#{is_an_object} was not validated as an object" )

    not_an_object = "Popular Music"

    invalid_json = {
      object: not_an_object
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "#{not_an_object} should not have validated as an object")
  end

  # Refers to validation of a JSON value attribute. This one is slightly tricky
  # though since attempting to access a Ruby Hash with a missing key will return
  # nil. The ValueValidator (or indeed any Validator) will accept nil as a value
  # when the value is not marked as required.
  # ValueValidator we will be stuck because although the other Validator
  # classes nil indicates a missing value, in the case of the ValueValidator null is
  # a valid value and we just want to check that there is a key available.
  test "As a user I want to validate json value attributes" do
      test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
        schema.has_value(key: :array)
        schema.has_value(key: :boolean)
        schema.has_value(key: :date)
        schema.has_value(key: :number)
        schema.has_value(key: :object)
        schema.has_value(key: :string)
        schema.has_value(key: :null)
      }.generate_node


      valid_json = {
        array: [],
        boolean: true,
        date: Date.today,
        number: 1.11,
        object: {},
        string: 'The Tenderness of Wolves',
        null: nil
      }.to_json

      assert(test_schema.valid?(valid_json), 'Value did not validate')

       # There is no 'negative' test for this validator at this stage, since
       # the lack of a value does not mean the key is required. See the tests
       # on required validation later on.
  end

  test "As a user I want to validate nested json objects" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
      schema.has_attribute(key: :level_1_attribute, opts: {type: :number})
      schema.contains_node(key: :level_2) do |n|
        n.has_attribute(key: :level_2_attribute, opts: {type: :number})
        n.contains_node(key: :level_3) do |n3|
          n3.has_attribute(key: :level_3_attribute, opts: {type: :number})
        end
      end
    }.generate_node

    valid_json = {
      level_1_attribute: 1,
      level_2:{
        level_2_attribute: 2,
        level_3:{
          level_3_attribute: 3
        }
      }
    }.to_json

    assert(test_schema.valid?(valid_json), "Nested JSON was not correctly validated")
  end

  test "As a user, if I specify a node and the content is not a node, it should be invalid without raising an error" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
      schema.has_attribute(key: :fish_name, opts: {type: :string, required: :true})
      schema.contains_node(key: :scientific_name) do |n|
        n.has_attribute(key: :genus, opts: {type: :string, required: :true})
        n.has_attribute(key: :species, opts: {type: :string, required: :true})
      end
    }.generate_node

    valid_json = {
      fish_name: 'Clownfish',
      scientific_name: {
        genus: 'Amphiprion',
        species: 'ocellaris'
      }
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been valid")

    invalid_with_array = {
      fish_name: 'Green Mandarin',
      scientific_name: ['Synchiropus', 'splendidus']
    }.to_json

    assert_not(test_schema.valid?(invalid_with_array), "#{invalid_with_array} should not have been valid as it has an array instead of a node")

    invalid_with_primitive = {
      fish_name: 'Hawaiian Tang',
      scientific_name: 'Zebrasoma flavescens'
    }.to_json

    assert_not(test_schema.valid?(invalid_with_primitive), "#{invalid_with_primitive} shoudl not have been valid as it has a primite instead of a node")
  end

  test "As a user I want to know why my json was not valid" do

    class Validator
      def valid?(json)
        raise EasyJSONMatcher::ValidationError.new ("Oops!!")
      end
    end

    test_schema = EasyJSONMatcher::SchemaGenerator.new { |schema|
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
