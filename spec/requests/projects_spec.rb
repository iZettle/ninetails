require 'rails_helper'

describe "Projects API" do

  describe "listing projects" do
    before do
      create_list :project, 5
    end

    it "should return the correct number of projects" do
      get "/projects"
      expect(response).to be_success
      expect(json["projects"].size).to eq 5
    end

    it "should include the id, name, and description for each project" do
      get "/projects"

      json["projects"].each do |project|
        expect(project).to have_key "id"
        expect(project).to have_key "name"
        expect(project).to have_key "description"
      end
    end
  end

  describe "creating projects" do
    let(:valid_project_params) { attributes_for(:project) }
    let(:invalid_project_params) { attributes_for :project, name: nil }

    it "should save the project if it is valid" do
      expect {
        post "/projects", project: valid_project_params
      }.to change{ Ninetails::Project.count }.by(1)
    end

    it "should show errors if the name is blank" do
      post "/projects", project: invalid_project_params

      expect(response).to_not be_success
      expect(json["project"]["errors"]["name"]).not_to be_empty
    end
  end

  describe "updating projects" do
    let(:project) { create :project }
    let(:new_valid_attributes) { attributes_for :project }
    let(:new_invalid_attributes) { attributes_for :project, name: nil }

    before do
      # call factory girl so the project exists before the tests run
      project
    end

    it "should update the project if it is valid" do
      put "/projects/#{project.id}", project: new_valid_attributes

      expect(response).to be_success
      expect(Ninetails::Project.find(project.id).name).not_to eq project.name
    end

    it "should not update the project if it is invalid" do
      put "/projects/#{project.id}", project: new_invalid_attributes
      expect(Ninetails::Project.find(project.id).name).to eq project.name
    end

    it "should show errors if the new params are invalid" do
      put "/projects/#{project.id}", project: new_invalid_attributes

      expect(response).to_not be_success
      expect(json["project"]["errors"]["name"]).not_to be_empty
    end

    it "should not create a new project" do
      expect {
        put "/projects/#{project.id}", project: new_valid_attributes
      }.not_to change{ Ninetails::Project.count }
    end
  end

end
