require 'easy_json_matcher/validator_factory'
require 'easy_json_matcher/node'
require 'easy_json_matcher/schema_library'
require 'easy_json_matcher/exceptions'
module EasyJSONMatcher
  class SchemaGenerator

    attr_reader :node, :name, :options, :glob_opts

    def initialize(opts: {}, global_opts: {})
      @name = opts.delete(:key)
      @options = opts
      @glob_opts = global_opts
      yield self if block_given?
    end

    def has_attribute(key:, opts: {})
      node.add_validator(key: key, validator: _create_validator(opts))
    end

    ################ Methods for adding specific attribute types ##############

    def contains_node(key:, opts: {})
      opts = opts.merge({ nested: true })
      generator = _node_generator(_validator_opts(opts))
      yield generator if block_given?
      node.add_validator key: key, validator: generator.generate_schema
    end

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

    def has_value(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :value}))
    end

    def has_string(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :string}))
    end

    def contains_array(key:, opts: {})
      opts = opts.merge!({type: :array})
      array_validator = _create_validator(opts)
      yield array_validator if block_given?
      node.add_validator key: key, validator: array_validator
    end

    def has_schema(key:, opts: {})
      has_attribute(key: key, opts: opts.merge({type: :schema}))
    end

    ################ Methods for generating the schema #########################

    def generate_schema
      if options[:nested]
        node
      else
        RootAdapter.new(node: node)
      end
    end

    def register(as:)
      SchemaLibrary.add_schema(name: as, schema: node)
      generate_schema
    end

    ################## Private methods #########################################

    def _prep_schema_opts(schema_name, opts)
      opts[:type] = :schema
      opts[:name] = schema_name
      opts
    end

    def _set_validator_key(validator, key)
      validator.key = key
    end

    def _validator_opts(opts)
      glob_opts.merge(opts)
    end

    def _create_validator(opts)
      ValidatorFactory.get_instance type: opts[:type], opts: _validator_opts(opts)
    end

    def _node_generator(opts = {})
     self.class.new opts: opts, global_opts: glob_opts
    end

    def node
      @node ||= Node.new(opts: _validator_opts(options))
    end
  end
end
