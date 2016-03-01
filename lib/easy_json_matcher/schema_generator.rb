require 'easy_json_matcher/validator_factory'
require 'easy_json_matcher/node'
require 'easy_json_matcher/schema_library'
require 'easy_json_matcher/exceptions'
module EasyJSONMatcher
  class SchemaGenerator

    attr_reader :node
    attr_reader :name

    def initialize(opts: {})
      @name = opts[:key]
      yield self if block_given?
    end

    def contains_node(key:, opts: {})
      generator = _node_generator _validator_opts(key, opts)
      yield generator if block_given?
      node.add_validator generator.generate_node
    end

    def has_attribute(key:, opts: {})
      node.add_validator(_create_validator(key, opts))
    end

    ################ Methods for adding specific attribute types ##############

    def has_boolean(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :boolean}))
    end

    def has_number(key: , opts: {})
      has_attribute(key: key, opts: opts.merge({type: :number}))
    end

    def has_date(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :date}))
    end

    def has_object(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :object}))
    end

    def has_value(key, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :value}))
    end

    def has_string(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :value}))
    end

    def contains_array(key:, opts: {})
      opts.merge!({type: :array})
      array_validator = _create_validator(key, opts)
      yield array_validator if block_given?
      node.add_validator array_validator
    end

    ################ Methods for generating the schema #########################

    def generate_node
      node
    end

    def register(schema_name:)
      SchemaLibrary.add_schema(name: schema_name, schema: generate_node)
      generate_node
    end

    ############# Private methods

    def _prep_schema_opts(schema_name, opts)
      opts[:type] = :schema
      opts[:name] = schema_name
      opts
    end

    def _set_validator_key(validator, key)
      validator.key = key
    end

    def _validator_opts(key, opts)
      opts[:key] = key
      opts
    end

    def _create_validator(key, opts)
      ValidatorFactory.get_instance type: opts[:type], opts: _validator_opts(key, opts)
    end

    def _node_generator(opts = {})
     self.class.new opts: opts
    end

    def node
      @node ||= Node.new(opts: _validator_opts(name, {}))
    end
  end
end
