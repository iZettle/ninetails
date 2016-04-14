FactoryGirl.define do

  factory :project_container, class: Ninetails::ProjectContainer do
    project
    container

    after :create do |project_container, evaluator|
      revision = create :revision, container: project_container.container, project: project_container.project
      project_container.update revision: revision
    end
  end

end
