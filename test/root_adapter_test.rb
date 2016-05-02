require "test_helper"

class RootAdapterTest < ActiveSupport::TestCase

  setup do
    @subject = EasyJSONMatcher::RootAdapter.new(node: Object.new)
  end

  def test_responds_to_valid?
    assert_respond_to(@subject, :valid?)
  end

  def test_responds_to_get_errors
    assert_respond_to(@subject, :get_errors)
  end

  test "It should forward valid? to the underlying node" do
    underlying_node = Minitest::Mock.new
    adapter = EasyJSONMatcher::RootAdapter.new(node: underlying_node)
    test_value = { a: 1 }
    underlying_node.expect :valid?, true, [test_value]
    adapter.valid? test_value.to_json
    underlying_node.verify
  end

  test "It should forward get_errors to the underlying node" do
    underlying_node = MiniTest::Mock.new
    adapter = EasyJSONMatcher::RootAdapter.new(node: underlying_node)
    underlying_node.expect(:get_errors, {})
    adapter.get_errors
    underlying_node.verify
  end

  test "It should coerce json strings into a Hash" do
    test_node = { a: 1, b: 2 }
    underlying_node = MiniTest::Mock.new
    adapter = EasyJSONMatcher::RootAdapter.new(node: underlying_node)
    underlying_node.expect(:valid?, true, [ test_node ])
    adapter.valid? test_node.to_json
    underlying_node.verify
  end
end

