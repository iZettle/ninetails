FactoryBot.define do

  factory :folder, class: Ninetails::Folder do
    sequence(:name) { |n| "Some folder #{n}" }
  end

end
