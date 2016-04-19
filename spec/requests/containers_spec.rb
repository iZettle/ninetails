require 'rails_helper'

describe "Pages API" do

  before do
    @layout = create :layout
    @page = create :page, layout: @layout
    @project = create :project
  end

  let(:page_url) { "/pages/#{@page.id}" }

  describe "listing pages" do
    before do
      create_list :page, 5
      create :layout
    end

    it "should return the correct number of containers" do
      get "/pages"
      expect(response).to be_success
      expect(json["containers"].size).to eq Ninetails::Page.count
    end

    it "should include the id and url for each container" do
      get "/pages"

      json["containers"].each do |container|
        expect(container).to have_key "id"
        expect(container).to have_key "url"
      end
    end

    it "should only include Page instances" do
      get "/pages"

      json["containers"].each do |page|
        expect(page["type"]).to eq "Page"
      end
    end
  end

  describe "showing a page" do
    describe "when not specifying revision" do
      describe "when the container exists" do
        before do
          get page_url
          expect(response).to be_success
        end

        it "should return the current revision of a page" do
          expect(json["container"]["revisionId"]).to eq @page.current_revision.id
        end

        it "should return a container with type Page" do
          expect(json["container"]["type"]).to eq "Page"
        end

        it "should include the page layout nested in a layout key" do
          expect(json["container"]["layout"]["container"]["id"]).to eq @layout.id
          expect(json["container"]["layout"]["container"]["type"]).to eq "Layout"
        end
      end

      describe "when the container does not exist" do
        it "should return a 404 if the id doesn't exist" do
          get "/pages/0"
          expect(response).to be_not_found
        end
      end
    end
  end

  describe "projects" do
    before do
      @pages = create_list :page, 5
      @other_page = create :page

      @pages.each do |container|
        create :revision, container: container, project: @project
      end
    end

    describe "when listing containers" do
      it "should return the number of containers which belong to the project" do
        get "/projects/#{@project.id}/pages"
        expect(json["containers"].length).to eq @pages.length
      end

      it "should not include containers which have not been changed in this project" do
        get "/projects/#{@project.id}/pages"
        expect(json["containers"].collect { |p| p["id"] }).not_to include @other_page.id
      end

      it "should be successfull if the project exists" do
        get "/projects/#{@project.id}/pages"
        expect(response).to be_success
      end

      it "should raise an error if the project does not exist" do
        get "/projects/foo/pages"
        expect(response).to_not be_success
      end
    end

    describe "when showing a container" do
      let(:project_container) { @project.project_containers.first }

      it "should use the current project container to fetch the latest revision" do
        get "/projects/#{@project.id}/pages/#{project_container.container_id}"
        expect(json["container"]["revisionId"]).to eq project_container.revision_id
      end

      it "should use the 'live' container when the container doesn't exist in the project scope" do
        new_container = create :container, :with_a_revision
        get "/projects/#{@project.id}/pages/#{new_container.id}"
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

    let(:existing_page_url_params) do
      {
        container: {
          name: "An existing container",
          url: @page.url,
          type: "Ninetails::Page"
        }
      }
    end

    it "should save the container if it is valid" do
      expect {
        post "/pages", valid_container_params
      }.to change{ Ninetails::Container.count }.by(1)
    end

    it "should show errors if the url is taken" do
      post "/pages", existing_page_url_params

      expect(response).to_not be_success
      expect(json["container"]["errors"]["url"]).not_to be_empty
    end

    it "should have a blank revision id" do
      post "/pages", valid_container_params
      expect(json["container"]["revisionId"]).to be_nil
    end

    it "should have an empty sections array" do
      post "/pages", valid_container_params
      expect(json["container"]["sections"]).to eq []
    end

    it "should create a project container if in the project scope" do
      expect {
        post "/projects/#{@project.id}/pages", valid_container_params
      }.to change{ @project.containers.count }.by(1)
    end

  end

  describe "when not specifying revision" do
    describe "when the container exists" do
      it "should return the current revision of a container" do
        get page_url

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq @page.current_revision.id
      end
    end

    describe "when the container does not exist" do
      it "should return a 404 if the id doesn't exist" do
        get "/pages/0"
        expect(response).to be_not_found
      end
    end
  end

  describe "when specifying a revision" do
    describe "when the container and revision exist" do
      it "should return the specified revision of the container when using the url to fetch the container" do
        new_revision = create :revision
        @page.revisions << new_revision

        get "#{page_url}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq new_revision.id
        expect(json["container"]["revisionId"]).not_to eq @page.current_revision.id
      end

      it "should return the specified revision of the container when using the id to fetch the container" do
        new_revision = create :revision
        @page.revisions << new_revision

        get "#{page_url}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to eq new_revision.id
        expect(json["container"]["revisionId"]).not_to eq @page.current_revision.id
      end
    end

    describe "when the container does not exist" do
      it "should return a 404" do
        get "/pages/nil"

        expect(response).to be_not_found
      end
    end

    describe "when the container exists, but the revision does not" do
      it "should return a 404" do
        get "#{page_url}?revision_id=bogus"

        expect(response).to be_not_found
      end
    end

    describe "when the container and revision exist, but are not related" do
      it "should return a 404" do
        revision = create :revision
        get "#{page_url}?revision_id=#{revision.id}"

        expect(response).to be_not_found
      end
    end
  end

end
