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

end
