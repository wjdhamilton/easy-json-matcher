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
        if schema = SCHEMAS[name]
          schema
        else
          lambda do |value|
            SCHEMAS[name]&.call(value: value) or raise MissingSchemaException.new(schema_name: name)
          end
        end
      end

        # TODO: this method should use get_schema to ensure schema presence is
        # checked
        def use_schema(name:, wrap_with: Validator)
          wrap_with.new validate_with: get_schema(name: name)
        end
      end
    end
  end
