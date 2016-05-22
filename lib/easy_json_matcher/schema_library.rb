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

      def get_schema(name:, opts: {})
        if schema = SCHEMAS[name]
          schema
        else
          ->(value:) { SCHEMAS[name]&.call(value: value) or raise MissingSchemaException.new }
        end
      end

      def use_schema(name:, wrap_with: Validator)
        wrap_with.new validate_with: get_schema(name: name)
      end
    end
  end
end
