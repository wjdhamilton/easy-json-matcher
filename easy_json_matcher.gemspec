$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easy_json_matcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easy_json_matcher"
  s.version     = JsonapiMatcher::VERSION
  s.authors     = ["WJD Hamilton"]
  s.email       = ["wjdhamilton@hotmail.co.uk"]
  s.homepage    = "https://github.com/wjdhamilton/easy-json-matcher"
  s.summary     = "Easily test your JSON output with templates and Schemas"
  s.description = "Test your JSON API with a simple set of classes, all written in Ruby. Simply define your JSON schemas and then pass the JSON to be tested to the schema's valid? method"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
