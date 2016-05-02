require 'test_helper'

class GlobalValidationOptionsTest < ActiveSupport::TestCase

  test 'As a user I want to be able to set validation options globally when defining the schema' do

    test_schema = EasyJSONMatcher::SchemaGenerator.new(global_opts: { required: true }) { |schema|
      schema.has_boolean key: :implicitly_required
      schema.contains_node key: :also_implicitly_required do |n|
        n.has_boolean key: :nested_implicitly_required
      end
    }.generate_schema

    invalid = {
      also_implicitly_required: {
      }
    }.to_json

    assert_not(test_schema.valid?invalid)
    implicitly_required_error = test_schema.get_errors[:implicitly_required][0]
    nested_implicitly_required_error = test_schema.get_errors[:also_implicitly_required][:nested_implicitly_required][0]
    error_message = /Value was not present/
    assert_match(error_message, implicitly_required_error)
    assert_match(error_message, nested_implicitly_required_error)
  end

  test 'As a user I want to be able to override global validation options for specific node' do

    test_schema = EasyJSONMatcher::SchemaGenerator.new(global_opts: { required: true }) { |schema|
      schema.has_boolean key: :implicitly_required
      schema.contains_node key: :also_implicitly_required do |n|
        n.has_boolean key: :nested_implicitly_required, opts: {required: false}
      end
    }.generate_schema

    invalid = {
      also_implicitly_required: {
      }
    }.to_json

    assert_not(test_schema.valid?invalid)
    implicitly_required_error = test_schema.get_errors[:implicitly_required][0]
    nested_implicitly_required_error = test_schema.get_errors[:also_implicitly_required]
    error_message = /Value was not present/
    assert_match(error_message, implicitly_required_error)
    assert(nested_implicitly_required_error.empty?)
  end
end
