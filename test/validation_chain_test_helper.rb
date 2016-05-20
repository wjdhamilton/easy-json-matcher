require "easy_json_matcher/validation_chain_factory"

module ValidationChainTestHelper

  def get_instance(type:)
    EasyJSONMatcher::ValidationChainFactory.get_step_for validating: type
  end

  def assert_chain_verifies(type:, test_value:, outcome:)
    v_step = get_instance(type: type)
    expect(v_step.call(value: test_value).empty?).must_be :==, outcome
  end
end
