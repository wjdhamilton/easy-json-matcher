require 'easy_json_matcher'
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

      def get_schema(name)
        SCHEMAS[name] or raise MissingSchemaException.new("No schema with #{name} has been registered")
      end
    end
  end
end
