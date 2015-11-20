namespace :ninetails_generate do

  desc "Generate a blank section as a hash"
  task :section, [:type] => :environment do |_, args|
    puts "Section::#{args[:type]}".safe_constantize.new.serialize
  end

end
