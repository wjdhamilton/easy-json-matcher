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
        schema = _find_and_clone_schema(name) or raise MissingSchemaException.new("No schema with #{name} has been registered")
        schema
      end

      def _find_and_clone_schema(name)
        s = SCHEMAS[name]
        return s.dup if s or nil
      end

      def _set_schema_key(schema, key)
        schema.key = key
      end
    end
  end
end
