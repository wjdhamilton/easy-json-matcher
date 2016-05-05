require "test_helper"
require "easy_json_matcher/validation_chain_factory"

module EasyJSONMatcher

  describe Node do

    describe "#add_validator" do

      it "should respond to #add_validator" do
        Node.new(validator: nil).must_respond_to :add_validator
      end

      it "should respond to #check" do
        Node.new(validator: nil).must_respond_to :check
      end

      it "should send call to its own validator" do
        validator = ValidationChainFactory.get_chain(steps: [:required, :object])
        test_value = { a: 1, b: 2, c: 3 }
        node = Node.new(validator: validator)
        node.add_validator(key: :a, validator: ValidationChainFactory.get_chain(steps: [:string]))
        node.add_validator(key: :b, validator: ValidationChainFactory.get_chain(steps: [:string]))
        node.add_validator(key: :c, validator: ValidationChainFactory.get_chain(steps: [:string]))
        expected = [{:a=>["1 is not a String"], :b=>["2 is not a String"], :c=>["3 is not a String"]}]
        node.check(value: test_value).must_be :==, expected
      end
    end
  end
end
