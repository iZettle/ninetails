require 'rails_helper'

describe Ninetails::ProjectContainer do

  let(:existing_container) { create :project_container }

  it "should require a project" do
    project_container = build :project_container, project: nil
    expect(project_container.valid?).to be false
    expect(project_container.errors[:project]).to include "can't be blank"
  end

  it "should require a container" do
    project_container = build :project_container, container: nil
    expect(project_container.valid?).to be false
    expect(project_container.errors[:container]).to include "can't be blank"
  end

  it "should not require a container revision" do
    project_container = build :project_container, revision: nil
    expect(project_container.valid?).to be true
  end

  describe "validating uniqueness of the container revision" do
    let(:duplicate_revision) { build :project_container, revision: existing_container.revision }
    let(:duplicate_container) { build :project_container, container: existing_container.container }
    let(:duplicate_revsion_in_project) { build :project_container, revision: existing_container.revision, project: existing_container.project }
    let(:duplicate_container_in_project) { build :project_container, container: existing_container.container, project: existing_container.project }

    it "should allow the same revision to be referenced in multiple projects" do
      expect(duplicate_revision.valid?).to be true
    end

    it "should allow the same container to be referenced in multiple projects" do
      expect(duplicate_container.valid?).to be true
    end

    it "should not allow the same container to have multiple revisions in the project" do
      expect(duplicate_revsion_in_project.valid?).to be false
      expect(duplicate_revsion_in_project.errors[:revision]).to include "has already been set for this container in the project"
    end

    it "should not allow the same container to be used in the same project" do
      expect(duplicate_container_in_project.valid?).to be false
      expect(duplicate_container_in_project.errors[:container]).to include "is already used in this project"
    end
  end

end
