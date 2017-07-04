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

    def initialize(opts: [], global_opts: [], **args, &block)
      super(**args)
      @glob_opts = global_opts
      @att_glob_opts = glob_opts.dup
      @att_glob_opts.delete(:strict)
      @node = new_node_generator(opts: opts, globals: global_opts)
      node.instance_eval &block if block_given?
    end

    def create_node(opts:)
      node.new(opts: opts)
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
