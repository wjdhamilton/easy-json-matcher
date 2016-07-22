module EasyJSONMatcher
  class SchemaGenerator
    include AutoInject.kwargs[
      :schema_library,
      :chain_factory,
      :node,
      :root_wrapper,
      :node_generator,
      :validator
    ]


    attr_reader :node, :glob_opts, :att_glob_opts

    def initialize(opts: [], global_opts: [], **args)
      super(**args)
      @glob_opts = global_opts
      @att_glob_opts = glob_opts.dup
      @att_glob_opts.delete(:strict)
      @node = new_node_generator(opts: opts, globals: global_opts)
      yield node if block_given?
    end

    def create_node(opts:)
      node.new(opts: opts)
    end

    def has_attribute(key:, opts:)
      opts = override_globals(local_opts: opts)
      opts = opts - [:strict]
      validator = validation_chain_factory.get_chain(steps: opts)
      node.add_validator key: key, validator: validator
    end

    # TODO pretty hacky but can be cleaned later
    def override_globals(local_opts:)
      if local_opts.include?(:not_required) && glob_opts.include?(:required)
         (local_opts + (glob_opts - [:required]))
      else
        local_opts + glob_opts
      end
    end

    ################ Methods for adding specific attribute types ##############

    def contains_node(key:, opts: [])
      generator = new_node_generator(opts: opts)
      yield generator if block_given?
      node.add_validator key: key, validator: generator.node
    end

    def contains_array(key:, opts: [], with_content:)
      array_validator = array_validator.new opts: opts, verify_content_as: with_content
      yield array_validator if block_given?
      node.add_validator key: key, validator: array_validator
    end

    def has_schema(key:, name:)
      schema = schema_library.get_schema(name: name)
      node.add_validator key: key, validator: schema
    end

    ################ Methods for generating the schema #########################

    def generate_node
      node.generate_node
    end

    def generate_schema
      validator.new validate_with: generate_node
    end

    def register(as:)
      schema_library.add_schema(name: as, schema: generate_node)
      generate_schema
    end

    def new_node_generator(opts:, globals:)
      node_generator.new(opts: opts, global_opts: globals)
    end
  end
end
