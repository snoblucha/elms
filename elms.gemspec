$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "elms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "elms"
  s.version     = Elms::VERSION
  s.authors     = ["Petr Snobl"]
  s.email       = ["snoblucha@email.cz"]
  s.homepage    = "TODO"
  s.summary     = "Provides export class for the ELMS service."
  s.description = "Elms service."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
