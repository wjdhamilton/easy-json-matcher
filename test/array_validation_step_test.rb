require 'test_helper'

module EasyJSONMatcher

  describe ArrayValidator do

    before do
      @subject = ArrayValidator.new
    end

    describe "Validating Array Types" do

      it "should return valid for empty arrays" do
        @subject.check(value: []).must_be :empty?
      end

      it "should return errors for any other object" do
        @subject.check(value: 1).wont_be :empty?
      end
    end
  end
end
