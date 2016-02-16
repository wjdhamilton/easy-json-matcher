require 'easy_json_matcher'
module EasyJSONMatcher
  # Override of Ruby error for namespacing
  class Error < RuntimeError; end

  # Exception thrown by SchemaLibrary when a Schema is requested that has not
  # already been registered
  class MissingSchemaException < Error; end
end
