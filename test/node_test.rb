require "test_helper"
require "easy_json_matcher/validation_chain_factory"

module EasyJSONMatcher

  describe Node do

    describe "#add_validator" do

      it "should respond to #check" do
        Node.new(validators: nil).must_respond_to :check
      end

      it "should send call to its own validator" do
        test_value = { a: 1, b: 2, c: 3 }
        validators = (:a..:c).each_with_object({}) do |n, h|
          h[n] = ValidationChainFactory.get_chain(steps: [:string])
        end
        node = Node.new(opts: [:required], validators: validators)
        expected = [{a: ["1 is not a String"],
                     b: ["2 is not a String"],
                     c: ["3 is not a String"]
        }]
        node.check(value: test_value).must_be :==, expected
      end
    end
  end
end
