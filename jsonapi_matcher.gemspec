$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "json_matcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "json_matcher"
  s.version     = JsonapiMatcher::VERSION
  s.authors     = ["WJD Hamilton"]
  s.email       = ["wjdhamilton@hotmail.co.uk"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of JsonapiMatcher."
  s.description = "TODO: Description of JsonapiMatcher."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
