Dir[File.join(File.expand_path('../../../spec/factories', __FILE__), "*.rb")].each do |file|
  require file
end
