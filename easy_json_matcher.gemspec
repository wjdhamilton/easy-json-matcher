$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easy_json_matcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easy_json_matcher"
  s.version     = EasyJSONMatcher::VERSION
  s.authors     = ["WJD Hamilton"]
  s.email       = ["wjdhamilton@hotmail.co.uk"]
  s.homepage    = "https://github.com/wjdhamilton/easy-json-matcher"
  s.summary     = "Easily test your JSON output with templates and Schemas"
  s.description = "Test your JSON output in Ruby, with a DSL that makes reasoning about your JSON very straightforward. See the Homepage for docs."
  s.license     = "MIT"

  # Runtime dependencies
  s.add_runtime_dependency 'dry-auto_inject', '~> 0.3'
  s.add_runtime_dependency 'dry-container', '~>0.3'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
