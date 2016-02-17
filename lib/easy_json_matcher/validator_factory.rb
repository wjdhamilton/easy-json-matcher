require 'easy_json_matcher/object_validator'
require 'easy_json_matcher/string_validator'
require 'easy_json_matcher/number_validator'
require 'easy_json_matcher/date_validator'
require 'easy_json_matcher/boolean_validator'
require 'easy_json_matcher/array_validator'
require 'easy_json_matcher/value_validator'
module EasyJSONMatcher
  class ValidatorFactory

    class << self
      def get_instance(type:, opts: {})
        raise "Type must be specified" unless type
        if type == :schema
          SchemaLibrary.get_schema(opts[:name])
        else
          validator_class = get_type(type)
          validator_class.new options: opts
        end
      end

      def get_type(name)
        case name
        when nil
          default_validator
        when :object
          object_validator
        when :string
          string_validator
        when :number
          number_validator
        when :date
          date_validator
        when :boolean
          boolean_validator
        when :array
          array_validator
        when :value
          value_validator
        end
      end

      def default_validator
        object_validator
      end

      def object_validator
        ObjectValidator
      end

      def string_validator
        StringValidator
      end

      def number_validator
        NumberValidator
      end

      def date_validator
        DateValidator
      end

      def boolean_validator
        BooleanValidator
      end

      def array_validator
        ArrayValidator
      end

      def value_validator
        ValueValidator
      end
    end
  end
end
