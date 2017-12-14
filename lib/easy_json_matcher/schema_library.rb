module EasyJSONMatcher
  class SchemaLibrary

    SCHEMAS = {}

    private_constant :SCHEMAS

    class << self

      def available_schemas
        SCHEMAS.keys
      end

      def schema_for(name)
        SCHEMAS[name]
      end

      def add_schema(name:, schema:)
        SCHEMAS[name] = schema
      end

      # TODO: error message should read "called #{name}, not with #{name}"
      def get_schema(name:, opts: {})
          -> (value:) {
            SCHEMAS[name]&.call(value: value) or raise UnknownValidationStepError.new(name)
          }
      end

      def use_schema(name:, wrap_with: Validator)
        wrap_with.new validate_with: get_schema(name: name)
      end
    end
  end
end
