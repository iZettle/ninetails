require 'rails_helper'

RSpec.describe Ninetails::Container, type: :model do

  let(:container) { create :container }

  describe "#load_revision_from_project" do

    before do
      @project = create :project
      @other_project = create :project
      @project_container = create :project_container, project: @project, container: container
    end

    it "should set the revision to the project container revision if one exists in the project" do
      expect {
        container.load_revision_from_project(@project)
      }.to change{ container.revision }.from(container.current_revision).to(@project_container.revision)
    end

    it "should not change the revision if the project has no versions of this container" do
      expect {
        container.load_revision_from_project(@other_project)
      }.not_to change{ container.revision }
    end
  end

end
