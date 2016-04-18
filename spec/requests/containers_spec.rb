require 'rails_helper'

describe "Containers API" do

  let(:project) { create :project }
  let(:container) { create :page }
  let(:container_url) { "/containers/#{CGI.escape(container.url)}" }
  let(:container_url_from_id) { "/containers/#{container.id}" }

  describe "listing containers" do
    before do
      create_list :container, 5
    end

    it "should return the correct number of containers" do
      get "/containers"
      expect(response).to be_success
      expect(json["containers"].size).to eq Ninetails::Container.count
    end

    it "should include the id and url for each container" do
      get "/containers"

      json["containers"].each do |container|
        expect(container).to have_key "id"
        expect(container).to have_key "url"
      end
    end
  end

  describe "projects" do
    before do
      @project_containers = create_list :page, 5
      @other_container = create :page

      @project_containers.each do |container|
        create :revision, container: container, project: project
      end
    end

    describe "when listing containers" do
      it "should return the number of containers which belong to the project" do
        get "/projects/#{project.id}/containers"
        expect(json["containers"].length).to eq @project_containers.length
      end

      it "should not include containers which have not been changed in this project" do
        get "/projects/#{project.id}/containers"
        expect(json["containers"].collect { |p| p["id"] }).not_to include @other_container.id
      end

      it "should be successfull if the project exists" do
        get "/projects/#{project.id}/containers"
        expect(response).to be_success
      end

      it "should raise an error if the project does not exist" do
        get "/projects/foo/containers"
        expect(response).to_not be_success
      end
    end

    describe "when showing a container" do
      let(:project_container) { project.project_containers.first }

      it "should use the current project container to fetch the latest revision" do
        get "/projects/#{project.id}/containers/#{project_container.container_id}"
        expect(json["container"]["revisionId"]).to eq project_container.revision_id
      end

      it "should use the 'live' container when the container doesn't exist in the project scope" do
        new_container = create :container, :with_a_revision
        get "/projects/#{project.id}/containers/#{new_container.id}"
        expect(json["container"]["revisionId"]).to eq new_container.revision.id
      end
    end
  end

  describe "creating a container" do

    let(:valid_container_params) do
      {
        container: {
          name: "A new container",
          url: "/foobar"
        }
      }
    end

    let(:existing_container_url_params) do
      {
        container: {
          name: "An existing container",
          url: container.url,
          type: "Ninetails::Page"
        }
      }
    end

    it "should save the container if it is valid" do
      expect {
        post "/containers", valid_container_params
      }.to change{ Ninetails::Container.count }.by(1)
    end

    it "should show errors if the url is taken" do
      post "/containers", existing_container_url_params

      expect(response).to_not be_success
      expect(json["container"]["errors"]["url"]).not_to be_empty
    end

    it "should have a blank revision id" do
      post "/containers", valid_container_params
      expect(json["container"]["revisionId"]).to be_nil
    end

    it "should have an empty sections array" do
      post "/containers", valid_container_params
      expect(json["container"]["sections"]).to eq []
    end

    it "should create a project container if in the project scope" do
      expect {
        post "/projects/#{project.id}/containers", valid_container_params
      }.to change{ project.containers.count }.by(1)
    end

  end

  describe "when not specifying revision" do
    describe "when the container exists" do
      it "should return the current revision of a container when using the url to fetch the container" do
        get container_url

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq container.current_revision.id
      end

      it "should return the current revision of a container when using the id to fetch the container" do
        get container_url_from_id

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq container.current_revision.id
      end
    end

    describe "when the container does not exist" do
      it "should return a 404 if the url doesn't exist" do
        get "/containers/nil"
        expect(response).to be_not_found
      end

      it "should return a 404 if the id doesn't exist" do
        get "/containers/0"
        expect(response).to be_not_found
      end
    end
  end

  describe "when specifying a revision" do
    describe "when the container and revision exist" do
      it "should return the specified revision of the container when using the url to fetch the container" do
        new_revision = create :revision
        container.revisions << new_revision

        get "#{container_url}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq new_revision.id
        expect(json["container"]["revisionId"]).not_to eq container.current_revision.id
      end

      it "should return the specified revision of the container when using the id to fetch the container" do
        new_revision = create :revision
        container.revisions << new_revision

        get "#{container_url_from_id}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq new_revision.id
        expect(json["container"]["revisionId"]).not_to eq container.current_revision.id
      end
    end

    describe "when the container does not exist" do
      it "should return a 404" do
        get "/containers/nil"

        expect(response).to be_not_found
      end
    end

    describe "when the container exists, but the revision does not" do
      it "should return a 404" do
        get "#{container_url}?revision_id=bogus"

        expect(response).to be_not_found
      end
    end

    describe "when the container and revision exist, but are not related" do
      it "should return a 404" do
        revision = create :revision
        get "#{container_url}?revision_id=#{revision.id}"

        expect(response).to be_not_found
      end
    end
  end

end
