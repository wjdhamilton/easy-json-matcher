require "test_helper"
require "easy_json_matcher/json_coercer"
require "easy_json_matcher/coercion_error"

module EasyJSONMatcher
  describe JsonCoercer do

    before do
      @subject = JsonCoercer.new
    end

    describe "#coerce" do

      it "should coerce a valid JSON string to a Hash" do
        valid_json = { a: 1, b: 2, c: 3}.to_json
        @subject.coerce(json: valid_json).must_be_instance_of Hash
      end

      it "should raise a JSONFormatError if json: is an invalid JSON string" do
        invalid_json = "123"
        -> { @subject.coerce(json: invalid_json) }.must_raise CoercionError
      end
    end
  end
end
