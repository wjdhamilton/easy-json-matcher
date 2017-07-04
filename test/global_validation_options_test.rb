require 'test_helper'

module EasyJSONMatcher

  describe "Global Validation Options" do


    subject {  
      SchemaGenerator.new(global_opts: [ :required ]) {
        has_boolean key: "implicitly_required"
        contains_node key: "also_implicitly_required" do 
          has_boolean key: "nested_implicitly_required"
          has_boolean key: "not_required", opts: [:not_required]
        end
      }.generate_schema
    }

    let(:invalid_candidate){
      {
        also_implicitly_required: {
          nested_implicitly_required: true
        }
      }.to_json
    }

    let(:valid_candidate){
      {
        implicitly_required: true,
        also_implicitly_required: {
          nested_implicitly_required: true
        }
      }.to_json
    }

    it "should only apply required to all implicitly required keys" do
      subject.valid?(candidate: valid_candidate).must_be :===, true
    end

    it "should apply required to all implicitly required keys" do
      subject.valid?(candidate: invalid_candidate).must_be :===, false
    end
  end
end
