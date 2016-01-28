require 'rails_helper'

describe Ninetails::ProjectPage do

  let(:existing_page) { create :project_page }

  it "should require a project" do
    project_page = build :project_page, project: nil
    expect(project_page.valid?).to be false
    expect(project_page.errors[:project]).to include "can't be blank"
  end

  it "should require a page" do
    project_page = build :project_page, page: nil
    expect(project_page.valid?).to be false
    expect(project_page.errors[:page]).to include "can't be blank"
  end

  it "should not require a page revision" do
    project_page = build :project_page, page_revision: nil
    expect(project_page.valid?).to be true
  end

  describe "validating uniqueness of the page revision" do
    let(:duplicate_revision) { build :project_page, page_revision: existing_page.page_revision }
    let(:duplicate_page) { build :project_page, page: existing_page.page }
    let(:duplicate_revsion_in_project) { build :project_page, page_revision: existing_page.page_revision, project: existing_page.project }
    let(:duplicate_page_in_project) { build :project_page, page: existing_page.page, project: existing_page.project }

    it "should allow the same revision to be referenced in multiple projects" do
      expect(duplicate_revision.valid?).to be true
    end

    it "should allow the same page to be referenced in multiple projects" do
      expect(duplicate_page.valid?).to be true
    end

    it "should not allow the same page to have multiple revisions in the project" do
      expect(duplicate_revsion_in_project.valid?).to be false
      expect(duplicate_revsion_in_project.errors[:page_revision]).to include "has already been set for this page in the project"
    end

    it "should not allow the same page to be used in the same project" do
      expect(duplicate_page_in_project.valid?).to be false
      expect(duplicate_page_in_project.errors[:page]).to include "is already used in this project"
    end
  end

end
