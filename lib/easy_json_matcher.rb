require "easy_json_matcher/container"
require "easy_json_matcher/node"
require "easy_json_matcher/schema_generator"
require "easy_json_matcher/validator_set"

module EasyJSONMatcher

  TYPES = [:number, :object, :value, :string, :boolean, :date, :array]

  IMPORT = Dry::AutoInject(Container)
end
