require 'test_helper'

class ValidatingArraysTest < ActiveSupport::TestCase

  setup do
    @test_schema = EasyJSONMatcher::SchemaGenerator.new { |s|
      s.has_attribute(key: :name, opts: {type: :string})
      s.contains_array(key: :items, opts: {required: true}) do |array|
        array.should_only_contain(type: :string, opts: {required: true})
      end
    }.generate_node
  end

  test "As a user I want to validate that my arrays contain values of the correct type" do
    valid_json = {
      name: 'Greek Heroes',
      items: ['Heracles', 'Perseus', 'Theseus', 'Achilles']
    }.to_json

    assert(@test_schema.valid?(valid_json), "#{valid_json} should have been valid")

    invalid_no_items = {
      name: 'Strictly Come Dancing Heroes'
    }.to_json

    assert_not(@test_schema.valid?(invalid_no_items), "#{invalid_no_items} should not have been valid as it has no array called items")

    invalid_wrong_items = {
      name: 'Prime Heroes',
      items: [1,3,5,7,9,8191]
    }.to_json

    assert_not(@test_schema.valid?(invalid_wrong_items), "#{invalid_wrong_items} should not have been validated since the array contains the wrong type")
  end

  test "As a user I want to validate that my arrays can contain objects of a specific schema" do
    EasyJSONMatcher::SchemaGenerator.new {|s|

      s.has_attribute key: :name, opts: {type: :string, required: true}
      s.has_attribute key: :spouse, opts: {type: :string}
    }.register(schema_name: :greek_hero)

    test_schema = EasyJSONMatcher::SchemaGenerator.new {|s|
      s.contains_array(key: :data, opts: {required: true}) do |a|
        a.should_only_contain(type: :schema, opts: {name: :greek_hero})
      end
    }.generate_node

    valid_json = {
      data: [{
          name: 'Greek Heroes',
          items: ['Hector', 'Ajax', 'Hippolyta', 'Penthesila']
        },
      {
        name: 'Roman Heroes',
        items: ['Romulus', 'Remus', 'Aeneus']
        }]
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been validated as it follows the correct schema")

    invalid_json = {
      data: [1,2,3,4,5]
    }

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have validated as it does not contain a :heroes schema")
  end
end
