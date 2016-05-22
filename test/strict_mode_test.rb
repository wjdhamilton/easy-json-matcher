require 'test_helper'

module EasyJSONMatcher

  describe "Strict Mode" do

    subject {
      SchemaGenerator.new(global_opts: [ :strict ]) { |s|
        s.has_attribute key: "a", opts: []
        s.has_attribute key: "b", opts: []
      }.generate_schema
    }


    it "should validate candidates with the correct keys" do
      candidate = {
        a: "a",
        b: "b"
      }.to_json

      subject.validate(candidate: candidate).must_be :empty?
    end

    it "should not validate candidates with extra keys" do
      candidate = {
        a: "a",
        b: "b",
        c: "c"
      }.to_json

      subject.validate(candidate: candidate).wont_be :empty?
    end
  end
end
