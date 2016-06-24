require "test_helper"

module EasyJSONMatcher

  describe NodeGenerator do

    before do 
      @generator = NodeGenerator.new
    end

    describe "#has_strings" do

      it "should allow you to require multiple strings" do
        @generator.has_strings(keys: [:a, :b, :c])
        schema = @generator.generate_node
        test_val = { a: "a", b: "b", c: "c" }
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "allows the user to set the same constraints on each key" do
        @generator.has_strings(keys: [:a, :b], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :a
        schema.call(value: test_val)[0].keys.must_include :b
      end
    end

    describe "has_booleans" do

      it "should allow you to require multiple booleans" do
        @generator.has_booleans(keys: [:true, :false])
        schema = @generator.generate_node
        test_val = { true: true, false: false }
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "allows the user to set the same constraints on each key" do
        @generator.has_booleans(keys: [:true, :false], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :true
        schema.call(value: test_val)[0].keys.must_include :false
      end
    end

    describe "#has_numbers" do

      it "should allow you to require multiple numbers" do
        @generator.has_numbers(keys: [:one, :two])
        schema = @generator.generate_node
        test_val = {one: 1, two: 2}
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "allows the user to set the same constraints on each key" do
        @generator.has_booleans(keys: [:one, :two], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :one
        schema.call(value: test_val)[0].keys.must_include :two
      end
    end

    describe "#has_dates" do

      it "should allow you to require multiple dates" do
        @generator.has_dates(keys: [:now, :then])
        schema = @generator.generate_node
        test_val = {now: "2016-06-24", then: "2016-06-23"}
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "should allow you to require multiple dates" do
        @generator.has_dates(keys: [:now, :then], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :now
        schema.call(value: test_val)[0].keys.must_include :then
      end
    end

    describe "#has_objects" do

      it "should allow you to require multiple objects" do
        @generator.has_objects(keys: [:a, :b])
        schema = @generator.generate_node
        test_val = {a: {}, b: {}}
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "should allow you to require multiple objects" do
        @generator.has_objects(keys: [:a, :b], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :a
        schema.call(value: test_val)[0].keys.must_include :b
      end
    end

    describe "#has_values" do

      it "should allow you to require multiple objects" do
        @generator.has_values(keys: [:a, :b])
        schema = @generator.generate_node
        test_val = {a: nil, b: nil}
        schema.call(value: test_val).empty?.must_be :==, true
      end

      it "should allow you to require multiple objects" do
        @generator.has_values(keys: [:a, :b], opts: [:required])
        schema = @generator.generate_node
        test_val = {}
        schema.call(value: test_val)[0].keys.must_include :a
        schema.call(value: test_val)[0].keys.must_include :b
      end
    end
  end
end
