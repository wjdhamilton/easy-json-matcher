module EasyJSONMatcher
  class SchemaGenerator
    include AutoInject.kwargs[:schema_library, :chain_factory, :node, :root_wrapper, :node_generator]

    attr_reader :root, :glob_opts

    def initialize(opts: [], global_opts: [], **args)
      super
      @glob_opts = global_opts
      @root = node_generator.new(opts: opts, global_opts: global_opts)
      yield root if block_given?
    end

    def generate_node
      root.generate_node
    end

    def generate_schema
      root_wrapper.new validate_with: generate_node
    end

    def register(as:)
      schema_library.add_schema(name: as, schema: generate_node)
      generate_schema
    end
  end
end
