require 'jsonapi_matcher/node'
require 'jsonapi_matcher/schema_generator'
module JSONAPIMatcher

    SCHEMAS = {}
    private_constant :SCHEMAS

    def self.available_schemas
      schemas.keys
    end

    def self.schema_for(name)
      schemas[name]
    end

    def self.add_schema(name:, schema:)
      schemas[name] = schema
    end

  private

    def self.schemas
      SCHEMAS
    end
end
