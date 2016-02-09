require 'jsonapi_matcher/object_validator'
require 'jsonapi_matcher/string_validator'
require 'jsonapi_matcher/number_validator'
require 'jsonapi_matcher/date_validator'
require 'jsonapi_matcher/boolean_validator'
require 'jsonapi_matcher/array_validator'
require 'jsonapi_matcher/value_validator'
module JSONAPIMatcher
  class ValidatorFactory

    class << self
      def create(opts)
        validator_class = get_type(opts[:type])
        validator_class.new options: opts
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
