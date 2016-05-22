require "dry-container"
require "dry-auto_inject"


module EasyJSONMatcher
  class Container
    extend Dry::Container::Mixin
  end

  AutoInject = Dry::AutoInject(Container)

  require "easy_json_matcher/node"
  require "easy_json_matcher/array_generator"
  require "easy_json_matcher/attribute_generator"
  require "easy_json_matcher/schema_library"
  require "easy_json_matcher/node_generator"
  require "easy_json_matcher/validation_chain_factory"
  require "easy_json_matcher/validator_set"
  require "easy_json_matcher/array_validator"
  require "easy_json_matcher/json_coercer"
  require "easy_json_matcher/array_content_validator"

  Container.register :node_generator, -> { NodeGenerator }
  Container.register :array_generator, -> { ArrayGenerator }
  Container.register :attribute_generator, -> { AttributeGenerator }
  Container.register :schema_library, -> { SchemaLibrary }
  Container.register :chain_factory, -> { ValidationChainFactory }
  Container.register :root_wrapper, -> { Validator }
  Container.register :node_content_validator, -> { ValidatorSet }
  Container.register :node, -> { Node }
  Container.register :array_validator, -> { ArrayValidator }
  Container.register :coercer, -> { JsonCoercer.new }
  Container.register :array_content_validator, -> { ArrayContentValidator }
end

