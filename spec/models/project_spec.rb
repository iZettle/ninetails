require 'rails_helper'

describe Ninetails::Project do

  let(:project) { create :project }

  before do
    create_list :project_page, 3, project: project
  end

  it "should have many project pages" do
    expect(project.project_pages.count).to eq 3
  end

  it "should have many pages through project pages" do
    expect(project.pages.count).to eq 3
  end

  it "should require a name" do
    invalid_project = build :project, name: nil
    expect(invalid_project.valid?).to be false
    expect(invalid_project.errors[:name]).to include "can't be blank"
  end

  describe "publishing" do
    it "should be unpublished by default" do
      expect(project.published?).to be false
    end

    it "should call #set_current_revision on each page with the correct revision" do
      project.project_pages.each do |project_page|
        expect(project_page.page).to receive(:set_current_revision).with(project_page.page_revision)
      end

      project.publish!
    end

    it "should be published after calling #publish!" do
      expect {
        project.publish!
      }.to change{ project.published? }.from(false).to(true)
    end
  end

end
