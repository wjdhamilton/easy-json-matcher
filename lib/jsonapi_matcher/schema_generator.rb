require 'jsonapi_matcher/validator_factory'
require 'jsonapi_matcher/node'
module JSONAPIMatcher
  class SchemaGenerator

    attr_reader :node

    def initialize(opts: {})
      yield self if block_given?
    end

    def contains_node(key:, opts: {})
      generator = _create_node
      yield generator if block_given?
      node.add_validator_for key: key, validator: generator.generate_node
    end

    def with_attribute(key:, opts: {})
      node.add_validator_for(key: key, validator: _create_validator(opts))
    end

    def _create_validator(opts)
      ValidatorFactory.create opts
    end

    def _create_node
     self.class.new
    end

    def generate_node
      @node
    end

    def register(name:)
      JSONAPIMatcher.add_schema(name: name, schema: generate_node)
    end

    def node
      @node ||= Node.new
    end
  end
end
