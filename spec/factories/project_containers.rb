FactoryBot.define do

  factory :project_container, class: Ninetails::ProjectContainer do
    project
    container

    trait :with_revision do
      after :create do |project_container, evaluator|
        revision = create :revision, container: project_container.container, project: project_container.project
        project_container.update revision: revision
      end
    end
  end

end
