require 'rails_helper'

describe "Project Containers API" do

  describe "listing projects which modify a container" do
    before do
      @project = create :project
      @project_container = create :project_container, project: @project
      @project_container_2 = create :project_container, container: @project_container.container

      get "/project_containers", params: { container_id: @project_container.container.id }
    end

    it "includes both projects which the container was modified in" do
      expect(json["projectContainers"].length).to eq 2
      expect(json["projectContainers"][0]["projectId"]).to eq @project.id
      expect(json["projectContainers"][1]["projectId"]).to eq @project_container_2.project.id
    end
  end

end
