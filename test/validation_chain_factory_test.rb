require "test_helper"
require "easy_json_matcher/validation_chain_factory"
require "easy_json_matcher/unknown_validation_step_error"

module EasyJSONMatcher

  describe ValidationChainFactory do

    STD_TYPES = [:object, :string, :number, :date, :boolean, :value, :required, :not_required]

    describe "#get_step_for" do

      it "should return a validation step for all available value types" do
        STD_TYPES.each do |type|
          ValidationChainFactory.get_step_for(validating: type).wont_be :==, nil
        end
      end

      it "should return a custom validator if :validating responds to call" do
        can_be_called = ->(value, errors) { }
        ValidationChainFactory.get_step_for(validating: can_be_called).
          wont_be :==, nil
      end

      it "should otherwise raise an error" do
        cannot_use = String.new
        -> { ValidationChainFactory.get_step_for(validating: cannot_use) }.
          must_raise UnknownValidationStepError
      end
    end

    describe "#get_chain" do

      it "should move :required validation to the start of the chain" do
        chain = ValidationChainFactory.get_chain(steps: [:string, :required])
        chain.call(value: nil)[0].must_match /(no value found)/
      end

      it "should put :not_required at the start if :required is not specified" do
        chain = ValidationChainFactory.get_chain(steps: [:string])
        chain.call(value: nil).must_be :empty?
      end
    end
  end
end
