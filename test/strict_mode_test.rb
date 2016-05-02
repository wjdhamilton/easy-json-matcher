require 'test_helper'

class StrictModeTest < ActiveSupport::TestCase

  test "As a user I want my schema to only validate objects iff the set of keys
        in the candidate minus the set of keys specified in the schema equals the
        empty set" do

    test_schema = EasyJSONMatcher::SchemaGenerator.new(global_opts: {strict: true}) {|s|
      s.has_string key: :first
      s.has_string key: :second
      s.has_string key: :third
    }.generate_schema

    too_many_planets = {
      first:  'Zeus',
      second: 'Poseidon',
      third:  'Hera',
      fourth: 'Demeter'
    }.to_json

    assert_not(test_schema.valid?(too_many_planets), "#{too_many_planets} should not be valid as it has the unspecified :fourth key")
  end

  setup do
    @test_schema = EasyJSONMatcher::SchemaGenerator.new(global_opts: {strict: true}) {|s|
      s.has_string key: :name
      s.contains_node key: :about do |n|
        n.has_string  key: :religion
        n.has_string  key: :domain
      end
    }.generate_schema
  end

  test "As a user, if I have specified strict at the top level, I expect it to apply to nested nodes" do

    poseidon = {
      name: 'Poseidon',
      about: {
        religion: 'Olympian Gods',
        domain: 'The Sea',
        hobbies: ['Battleships Champion', 'Horse Tamer', 'Seismology']
      }
    }.to_json

    assert_not(@test_schema.valid?(poseidon), "#{poseidon} should not be valid as hobbies wasn't expected in the schema, and he didn't have any")
  end

  test "As a user, if the strict validation fails, I want to be told why" do
    zeus = {
      name: 'Zeus',
      about: {
        religion: 'Olympian Gods',
        domain: 'Firmament',
        spouse: 'Hera',
        address: 'Mount Olympus'
      }
    }.to_json

    skip "Await completion of error reporting refactoring"
    assert_match(/\[:spouse, :address\] found in addition to expected keys/, @test_schema.get_errors[:about][:node_errors_][0])
  end
end
