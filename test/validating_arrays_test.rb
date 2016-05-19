require 'test_helper'
require "easy_json_matcher/array_validator"

module EasyJSONMatcher

  describe ArrayValidator do

    before do
      SchemaGenerator.new {|s|
        s.has_attribute key: :name, opts: [:string, :required]
        s.has_attribute key: :spouse, opts: [:string, :required]
      }.register as: :greek_hero
    end 

    subject{
      test_schema = SchemaGenerator.new {|s|
        s.contains_array(key: :data) do |a|
          a.elements_should be: [:greek_hero]
        end
      }.generate_schema
    }

    it "should validate each value in the array" do
      validator = SchemaGenerator.new { |s|
        s.contains_array(key: :array) do |a|
          a.elements_should be: [:number]
        end
      }.generate_schema
      candidate = { array: [1,2,3,4,"oops"] }.to_json
      validator.validate(candidate: candidate).wont_be :empty?
    end

    it "should validate schemas" do
      invalid_json = {
        data: [{
          name: 'More Greek Heroes',
          items: ['Hector', 'Ajax', 'Hippolyta', 'Penthesila']
        },
        {
          name: 'Roman Heroes',
          items: ['Romulus', 'Remus', 'Aeneus']
        }]
      }.to_json
      subject.validate(candidate: invalid_json).wont_be :empty?
    end
  end
end
