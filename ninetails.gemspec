$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ninetails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ninetails"
  s.version     = Ninetails::VERSION
  s.authors     = ["Damien Timewell"]
  s.email       = ["damien@izettle.com"]
  s.homepage    = "https://www.izettle.com"
  s.summary     = "Summary of Ninetails."
  s.description = "Description of Ninetails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "rails-api", "~> 0.4.0"
  s.add_dependency "pg", "~> 0.18.4"
  s.add_dependency "jbuilder", "~> 2.3.2"
  s.add_dependency "hash-pipe", "~> 0.3.0"
  s.add_dependency "virtus", "~> 1.0.5"

  s.add_development_dependency "pry"
  s.add_development_dependency "web-console"
  s.add_development_dependency "spring"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "factory_girl_rails"

  s.test_files = Dir["spec/**/*"]
end
