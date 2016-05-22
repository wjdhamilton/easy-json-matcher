require "test_helper"
require "easy_json_matcher/validator"

module EasyJSONMatcher
  describe Validator do

    describe "#valid?" do

      before do
        @v_step = Minitest::Mock.new
        @subject = Validator.new(validate_with: @v_step)
      end

      it "should use a ValidationStep chain to verify candidates" do
        @v_step.expect(:call, {}, [Hash])
        @subject.valid? candidate: Hash.new.to_json
        @v_step.verify
      end

      it "should return false if any errors are generated" do
        @v_step.expect(:call, { a: 1, b: 2, c: 3 }, [Hash])
        @subject.valid?(candidate: Hash.new.to_json).must_be :==, false
      end

      it "should return true if no errors are generated" do
        @v_step.expect(:call, {}, [Hash])
        @subject.valid?(candidate: Hash.new.to_json).must_be :==, true
      end
    end

    describe "#validate" do

      before do
        @v_step = Minitest::Mock.new
        @subject = Validator.new(validate_with: @v_step)
      end

      it "should call call on its verifier" do
        @v_step.expect(:call, Hash.new, [Hash])
        test_value = { a: 1, b: 2, c: 3 }.to_json
        @subject.validate(candidate: test_value)
      end
    end
  end
end
