require 'rails_helper'

describe "Project Containers API" do

  describe "listing projects which modify a container" do
    before do
      @project = create :project
      @project_container = create :project_container, project: @project
      @project_container_2 = create :project_container, container: @project_container.container

      get "/containers/#{@project_container.container.id}/projects"
    end

    it "includes both projects which the container was modified in" do
      expect(json["projects"].length).to eq 2
      expect(json["projects"][0]["id"]).to eq @project.id
      expect(json["projects"][1]["id"]).to eq @project_container_2.project.id
    end
  end

end
