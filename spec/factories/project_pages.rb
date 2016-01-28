FactoryGirl.define do

  factory :project_page, class: Ninetails::ProjectPage do
    project
    page

    after :create do |project_page, evaluator|
      revision = create :page_revision, page: project_page.page, project: project_page.project
      project_page.update page_revision: revision
    end
  end

end
