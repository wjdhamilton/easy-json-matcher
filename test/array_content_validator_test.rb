require "test_helper"
require "easy_json_matcher/array_content_validator"

module EasyJSONMatcher
  describe ArrayContentValidator do

    it "should call all the elements in an array" do
      mock_values = (1..5).map do |n| 
        mock_val = Minitest::Mock.new
        mock_val.expect(:hello, "hi")
      end
      subject = ArrayContentValidator.new( verify_with: ValidationStep.new(verify_with: ->(value, errors) { value.hello }))
      subject.call value: mock_values
      mock_values.each(&:verify)
    end
  end
end
