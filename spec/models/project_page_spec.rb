require 'rails_helper'

describe Ninetails::ProjectPage do

  let(:project_page) { create :project_page }

  describe "validating uniqueness of the page revision" do
    let(:duplicate_revision) { Ninetails::ProjectPage.new page_revision: project_page.page_revision }
    let(:duplicate_page) { Ninetails::ProjectPage.new page: project_page.page }
    let(:duplicate_revsion_in_project) { Ninetails::ProjectPage.new page_revision: project_page.page_revision, project: project_page.project }
    let(:duplicate_page_in_project) { Ninetails::ProjectPage.new page: project_page.page, project: project_page.project }

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
