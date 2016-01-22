FactoryGirl.define do

  factory :project, class: Ninetails::Project do
    sequence(:name) { |n| "Some project #{n}" }
    description "This is a project about things"
  end

end
