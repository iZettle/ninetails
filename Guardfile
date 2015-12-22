guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w(jbuilder))
  dsl.watch_spec_files_for(rails.app_files)

  # Engine stuff
  watch(%r{^app/(.+)/ninetails/(.+)\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/ninetails/(.+)_controller\.rb$}) { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^app/views/ninetails/(.+)/(.+)\.json.jbuilder$}) { |m| "spec/requests/#{m[1]}_spec.rb" }

  # Config changes
  watch(rails.spec_helper) { rspec.spec_dir }
end
