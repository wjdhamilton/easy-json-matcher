require "easy_json_matcher/validation_chain_factory"
require "easy_json_matcher/node"
require "easy_json_matcher/schema_library"
require "easy_json_matcher/validator"
require "easy_json_matcher/attribute_type_methods"

module EasyJSONMatcher
  class SchemaGenerator
    include AttributeTypeMethods

    attr_reader :node, :glob_opts, :att_glob_opts

    def initialize(opts: [], global_opts: [])
      @glob_opts = global_opts
      @att_glob_opts = glob_opts.dup
      @att_glob_opts.delete(:strict)
      @node = create_node(opts: opts)
      yield self if block_given?
    end

    def create_node(opts:)
      Node.new(opts: opts)
    end

    def has_attribute(key:, opts:)
      opts = override_globals(local_opts: opts)
      opts = opts - [:strict]
      validator = ValidationChainFactory.get_chain(steps: opts)
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
      generator = node_generator(opts: opts)
      yield generator if block_given?
      node.add_validator key: key, validator: generator.node
    end

    def contains_array(key:, opts: [], with_content:)
      array_validator = ArrayValidator.new opts: opts, verify_content_as: with_content
      yield array_validator if block_given?
      node.add_validator key: key, validator: array_validator
    end

    def has_schema(key:, name:)
      schema = SchemaLibrary.get_schema(name: name)
      node.add_validator key: key, validator: schema
    end

    ################ Methods for generating the schema #########################

    def generate_schema
      Validator.new validate_with: node
    end

    def register(as:)
      SchemaLibrary.add_schema(name: as, schema: node)
      generate_schema
    end

    def node_generator(opts: {})
     self.class.new opts: opts, global_opts: glob_opts
    end
  end
end
