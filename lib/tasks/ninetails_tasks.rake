namespace :ninetails do

  desc "Generate a blank section as a hash"
  task :generate_section, [:type] => :environment do |_, args|
    puts "Section::#{args[:type]}".safe_constantize.new.serialize
  end

  task seed: :environment do
    Ninetails::Seeds::Generator.run
  end

  task reseed: :environment do
    [
      Ninetails::Container,
      Ninetails::ContentSection,
      Ninetails::RevisionSection,
      Ninetails::Revision
    ].each do |model|
      model.delete_all
    end

    Ninetails::Seeds::Generator.run
  end

end
