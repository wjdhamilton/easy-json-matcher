module EasyJSONMatcher
  class SchemaLibrary

    SCHEMAS = {}
    private_constant :SCHEMAS
    class << self
      def available_schemas
        schemas.keys
      end

      def schema_for(name)
        schemas[name]
      end

      def add_schema(name:, schema:)
        schemas[name] = schema
      end

      def schemas
        SCHEMAS
      end

      def get_schema(name:, opts: {})
         schema = _find_and_clone_schema(name) or raise MissingSchemaException.new("No schema with #{name} has been registered")
        _set_schema_key(schema, opts.delete(:key))
        schema
      end

      def _find_and_clone_schema(name)
        s = SCHEMAS[name]
        return s.dup if s
        nil
      end

      def _set_schema_key(schema, key)
        schema.key = key
      end
    end
  end
end
