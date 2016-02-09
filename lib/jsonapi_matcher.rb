require 'jsonapi_matcher/node'
require 'jsonapi_matcher/schema_generator'
module JSONAPIMatcher

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
  end

  # Override of Ruby error for namespacing
  class Error < RuntimeError; end
end
