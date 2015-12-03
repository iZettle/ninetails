require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

require "rails-api"
require "pg"
require "jbuilder"
require "hash-pipe"
require "virtus"

require "ninetails/config"
require "ninetails/key_conversion"

begin
  require "pry"
rescue LoadError
end

module Ninetails
  class Engine < ::Rails::Engine
    isolate_namespace Ninetails

    middleware.use "Ninetails::KeyConversion"

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
