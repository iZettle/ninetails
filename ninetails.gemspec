$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ninetails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "ninetails"
  s.version = Ninetails::VERSION
  s.authors = ["Damien Timewell"]
  s.email = ["damien@izettle.com"]
  s.homepage = "https://github.com/iZettle/ninetails"
  s.summary = "Structured CMS API for Rails"
  s.description = %(
    Ninetails is a structured API for building a CMS API in Rails.
    It lets you define Sections, Elements, and Properties which control what can and cannot be edited.
  )
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"
  # s.add_dependency "rails-api", "~> 0.4"
  s.add_dependency "pg", "~> 0.18"
  s.add_dependency "jbuilder", ">= 2.6"
  s.add_dependency "hash-pipe", ">= 0.4"
  s.add_dependency "virtus", ">= 1.0"
  s.add_dependency "paranoia", ">= 2.2"

  s.add_development_dependency "pry", ">= 0.10"
  s.add_development_dependency "spring", ">= 1.7"
  s.add_development_dependency "spring-commands-rspec", ">= 1.0"
  s.add_development_dependency "rspec-rails", ">= 3.5"
  s.add_development_dependency "guard-rspec", ">= 4.6"
  s.add_development_dependency "factory_girl", ">= 4.7"
  s.add_development_dependency "factory_girl_rails", ">= 4.7"
  s.add_development_dependency "codeclimate-test-reporter", ">= 0.6"
  s.add_development_dependency "shoulda-matchers", ">= 3.1"

  s.test_files = Dir["spec/**/*"]
end
