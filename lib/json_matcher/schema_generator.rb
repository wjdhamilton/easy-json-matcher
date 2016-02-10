require 'json_matcher/validator_factory'
require 'json_matcher/node'
module JSONAPIMatcher
  class SchemaGenerator

    attr_reader :node
    attr_reader :name

    def initialize(opts: {})
      @name = opts[:key]
      yield self if block_given?
    end

    def contains_node(key:, opts: {})
      generator = _node_generator validator_opts(key, opts)
      yield generator if block_given?
      node.add_validator generator.generate_node
    end

    def has_attribute(key:, opts: {})
      node.add_validator(_create_validator(validator_opts(key, opts)))
    end

    def validator_opts(key, opts)
      opts[:key] = key
      opts
    end

    def _create_validator(opts)
      ValidatorFactory.create opts
    end

    def _node_generator(opts = {})
     self.class.new opts: opts
    end

    def generate_node
      node
    end

    def register(schema_name:)
      JSONAPIMatcher.add_schema(name: schema_name, schema: generate_node)
    end

    def node
      @node ||= Node.new(opts: validator_opts(name, {}))
    end
  end
end
