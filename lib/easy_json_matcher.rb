require 'easy_json_matcher/node'
require 'easy_json_matcher/schema_generator'
module EasyJSONMatcher

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
