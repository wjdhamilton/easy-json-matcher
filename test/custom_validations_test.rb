require 'test_helper'

module EasyJSONMatcher

  describe "Custom Validations" do

    subject { 
      SchemaGenerator.new {
        has_attribute key: "val", 
          opts: [
            :required,
            ->(value, errors) { errors << "value was false" unless value === true }
        ]
      }.generate_schema
    }

    it "should pass where val => true" do
      subject.validate( candidate: { val: true }.to_json ).must_be :empty?
    end

    it "should show an error where val => false" do
      subject.validate( candidate: { val: false }.to_json ).wont_be :empty?
    end
  end
end
