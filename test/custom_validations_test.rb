require 'test_helper'

class CustomValidationsTest < ActiveSupport::TestCase

  test 'As a user, I want to be able to specify custom validations' do
    test_schema = EasyJSONMatcher::SchemaGenerator.new do |s|
      string_validator = ->(candidate) { "String did not say 'hi'" unless candidate == 'hi' }
      s.has_string key: :a_string, opts: { custom_validator: string_validator }
    end.generate_schema

    should_validate = {
      a_string: 'hi'
    }.to_json

    assert(test_schema.valid?(should_validate), test_schema.get_errors)

    should_not_validate = {
      a_string: 'go away'
    }.to_json

    assert_not(test_schema.valid?(should_not_validate))
  end
end
