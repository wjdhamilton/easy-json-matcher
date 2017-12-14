require "easy_json_matcher/attribute_type_methods"

module EasyJSONMatcher
  class NodeGenerator
    include AutoInject.kwargs[:node, :attribute_generator, :array_generator, :schema_library]
    include AttributeTypeMethods

    attr_reader :validators, :attribute_opts, :node_opts, :array_opts, :global_opts

    def initialize(opts: [], global_opts: [], **args)
      super(**args)
      @validators = {} 
      @node_opts = extract_opts(local: opts, global: global_opts)
      @global_opts = global_opts
    end

    def generate_node
      strict = node_opts.delete(:strict)
      node.new(opts: node_opts, strict: strict, validators: validators)
    end

    def has_attribute(key:, opts: [])
      validator = attribute_generator.new(local_opts: opts, global_opts: global_opts)
      validators[key] = validator.generate_attribute
    end

    def contains_node(key:, opts: [], &block)
      generator = self.class.new(opts: opts, global_opts: global_opts)
      generator.instance_eval &block if block_given?
      validators[key] = generator.generate_node
    end

    def contains_array(key:, opts: [], &block)
      validator = array_generator.new(local_opts: opts, global_opts: global_opts)
      validator.instance_eval &block if block_given?
      validators[key] = validator.generate_array
    end

    def has_schema(key:, name:)
      schema = schema_library.get_schema(name: name)
      validators[key] = schema
    end

    def extract_opts(local:, global:)
      conflicts = { required: :not_required }
      global.map do |opt| 
        if conflicts.keys.include? opt
          local.include?(conflicts[opt]) ? conflicts[opt] : opt
        else
          opt
        end
      end
    end
  end
end
