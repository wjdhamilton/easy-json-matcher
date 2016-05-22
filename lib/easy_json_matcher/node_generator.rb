require "easy_json_matcher/validation_chain_factory"
require "easy_json_matcher/node"
require "easy_json_matcher/schema_library"
require "easy_json_matcher/attribute_type_methods"
require "easy_json_matcher/attribute_generator"
require "easy_json_matcher/array_generator"

module EasyJSONMatcher
  class NodeGenerator
    include AttributeTypeMethods

    attr_reader :validators, :attribute_opts, :node_opts, :array_opts, :global_opts

    def initialize(opts: [], global_opts: [])
      @validators = {} 
      @node_opts = extract_opts(local: opts, global: global_opts)
      @global_opts = global_opts
    end

    def generate_node
      strict = node_opts.delete(:strict)
      Node.new(opts: node_opts, strict: strict, validators: validators)
    end

    def has_attribute(key:, opts: [])
      validator = AttributeGenerator.new(local_opts: opts, global_opts: global_opts)
      validators[key] = validator.generate_attribute
    end

    def contains_node(key:, opts: [])
      generator = self.class.new(opts: opts, global_opts: global_opts)
      yield generator if block_given?
      validators[key] = generator.generate_node
    end

    def contains_array(key:, opts: [])
      validator = ArrayGenerator.new(local_opts: opts, global_opts: global_opts)
      yield validator if block_given?
      validators[key] = validator.generate_array
    end

    def has_schema(key:, name:)
      schema = SchemaLibrary.get_schema(name: name)
      validators[key] = schema
    end

    def extract_opts(local:, global:)
      conflicts = { required: :not_required }
      opts = global.map do |opt| 
        if conflicts.keys.include? opt
          local.include?(conflicts[opt]) ? conflicts[opt] : opt
        else
          opt
        end
      end
    end
  end
end
