require 'test_helper'

class ValidatingArraysTest < ActiveSupport::TestCase

  test "As a user I want to validate that my arrays can contain objects of a specific schema" do
    EasyJSONMatcher::SchemaGenerator.new {|s|

      s.has_attribute key: :name, opts: {type: :string, required: true}
      s.has_attribute key: :spouse, opts: {type: :string}
    }.register as: :greek_hero

    test_schema = EasyJSONMatcher::SchemaGenerator.new {|s|
      s.contains_array(key: :data, opts: {required: true}) do |a|
        a.should_only_contain(type: :schema, opts: {name: :greek_hero})
      end
    }.generate_schema

    valid_json = {
      data: [{
          name: 'More Greek Heroes',
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
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have validated as it does not contain a :heroes schema")
  end

  test "As a user I want to validate that my arrays only contain strings" do
    test_schema = EasyJSONMatcher::SchemaGenerator.new {|s|
      s.has_string key: :name, opts: {required: true}
      s.contains_array key: :data, opts: {required: true} do |a|
        a.should_only_contain_strings
      end
    }.generate_schema

    valid_json = {
      name: 'German Heroes',
      data: ['Brunhilda', 'Siegfried', 'Faust']
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been valid as it only contained strings")

    invalid_json = {
      name: 'Fibonacci sequence',
      data: [0,1,1,2,3,5,8,13,24]
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have been valid as it did not contain strings")

  end

  test 'As a user I want to validate that my arrays only contain numbers' do
    test_schema = EasyJSONMatcher::SchemaGenerator.new {|s|
      s.has_string key: :name, opts: {required: true}
      s.contains_array key: :data, opts: {required: true} do |a|
        a.should_only_contain_numbers
      end
    }.generate_schema

    valid_json = {
      name: 'Square Numbers',
      data: [1,4,9,16,25,36,49,64]
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been valid as it contained only numbers")

    invalid_json = {
      name: 'Notable Scots',
      data: ['Alexander Fleming', 'Adam Smith', 'John Logie Baird', 'St. Andrew', 'St. Columba', 1, 2, 3, 4, 5]
    }.to_json
    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have been valid as it did not only contain numbers")
  end

  test 'As a user I want to validate that my arrays only contain booleans' do

    test_schema = EasyJSONMatcher::SchemaGenerator.new {|s|
      s.has_string key: :name, opts: {required: true}
      s.contains_array key: :data, opts: {required: true} do |a|
        a.should_only_contain_booleans
      end
    }.generate_schema

    valid_json = {
      name: 'Predicates',
      data: [true, true, false, true, false, false]
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been valid as it contains only booleans")

    invalid_json = {
      name: 'Notable English',
      data: ['St. George', 'Winston Churchill', 'Admiral Nelson', true, true, false, false]
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should have been invalid as it contains strings")
  end

  test 'As a user I want to validate that my arrays contain only objects' do

    test_schema = EasyJSONMatcher::SchemaGenerator.new { |s|
      s.has_string key: :name, opts: {required: true}
      s.contains_array key: :data, opts: {required: true} do |a|
        a.should_only_contain_objects
      end
    }.generate_schema

    valid_json = {
      name: 'Hand of Cards',
      data: [
        {suite: 'Spades', value: 'Ace'},
        {suite: 'Hearts', value: 'Queen'},
        {suite: 'Clubs', value: 'Jack'},
        {suite: 'Diamonds', value: '3'}]
    }.to_json

    assert(test_schema.valid?(valid_json), "#{valid_json} should have been valid as it only contains objects")

    invalid_json = {
      name: 'Norse Gods',
      data: [{'Thor': 'Thunder'}, 'Odin', 'Loki', 'Freya']
    }.to_json

    assert_not(test_schema.valid?(invalid_json), "#{invalid_json} should not have been valid as it does not only contain objects")
  end

  test 'as a user I want to validate that my arrays contain only dates' do

  end
end
