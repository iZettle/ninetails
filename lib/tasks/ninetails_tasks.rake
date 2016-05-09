namespace :ninetails do

  desc "Generate a blank section as a hash"
  task :generate_section, [:type] => :environment do |_, args|
    puts "Section::#{args[:type]}".safe_constantize.new.serialize
  end

  task seed: :environment do
    Ninetails::Seeds.run
  end

end
