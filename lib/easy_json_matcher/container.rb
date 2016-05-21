require "dry-container"
require "dry-auto_inject"
require "easy_json_matcher/node"
require "easy_json_matcher/array_generator"
require "easy_json_matcher/attribute_generator"
require "easy_json_matcher/schema_library"


module EasyJSONMatcher
  class Container
    extend Dry::Container::Mixin
  end

  Container.register "node", -> { Node }
  Container.register "array_generator", -> { ArrayGenerator }
  Container.register "attribute_generator", -> { AttributeGenerator }
  Container.register "schema_library", -> { SchemaLibrary }

  AutoInject = Dry::AutoInject(Container)
  require "byebug"
  byebug
end

