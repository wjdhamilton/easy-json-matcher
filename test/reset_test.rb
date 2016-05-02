require 'test_helper'

class ResetTest < ActiveSupport::TestCase

  test 'As a user, I want to be able to reuse a validator' do
    # In other words, after a valid? has been called, the error messages need to be cleared
    test_schema = EasyJSONMatcher::SchemaGenerator.new(global_opts: { strict: true }) { |sc|
      sc.has_boolean key: :bool, opts: { required: true }
      sc.contains_node key: :node do |n|
        n.has_value key: :val
      end
    }.generate_schema

    invalid_json = {
      string: "not valid for this schema"
    }.to_json

    assert_not(test_schema.valid?(invalid_json))

    test_schema.reset!

    valid_json = {
      bool: true
    }.to_json

    
    assert(test_schema.valid?(valid_json), test_schema.get_errors)

    errors = test_schema.get_errors
    assert errors[:node][:val].empty?
    assert errors[:bool].empty?
  end
end
