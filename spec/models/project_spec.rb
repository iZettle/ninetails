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

end
