require 'test_helper'

class RequireValidationTest < ActiveSupport::TestCase

  test "As a user I want to insist that a value is present" do
    astronaut_schema = EasyJSONMatcher::SchemaGenerator.new {
      has_attribute key: "has_oxygen", opts: [:boolean, :required]
      has_attribute key: "name", opts: [:string]
    }.generate_schema

    valid_astronaut = {
      has_oxygen: true,
      name: 'Buzz Aldrin'
    }.to_json

    assert(astronaut_schema.valid?(candidate: valid_astronaut), "#{valid_astronaut} should be a valid object")

    invalid_astronaut = {
      name: 'Neil Armstrong'
    }.to_json

    assert_not(astronaut_schema.valid?(candidate: invalid_astronaut), "#{invalid_astronaut} should not be a valid object")
  end

  test "As a user I want validations to pass if the value is not present and I have not required it to be there" do
    astronaut_schema = EasyJSONMatcher::SchemaGenerator.new {
      has_attribute key: "has_oxygen", opts: [:boolean]
      has_attribute key: "name", opts: [:string]
    }.generate_schema

    valid_astronaut = {
      name: 'Buzz Aldrin'
    }.to_json

    assert(astronaut_schema.valid?(candidate: valid_astronaut), "#{valid_astronaut} should be valid since :has_oxygen is not required")
  end
end
