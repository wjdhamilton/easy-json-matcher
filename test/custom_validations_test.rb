require 'test_helper'

class CustomValidationsTest < ActiveSupport::TestCase

  test 'As a user, I want to be able to specify custom validations' do
    test_schema = EasyJSONMatcher::SchemaGenerator.new do |s|
      s.has_string key: :a_string, opts: { custom_validator: ->(candidate) { "String did not say 'hi'" unless candidate == 'hi' } }
    end.generate_schema

    should_not_validate = {
      a_string: 'go away'
    }.to_json

    assert_not(test_schema.valid? should_not_validate)

    should_validate = {
      a_string: 'hi'
    }.to_json


    test_schema.reset!

    assert(test_schema.valid?(should_validate), test_schema.get_errors)

  end
end
