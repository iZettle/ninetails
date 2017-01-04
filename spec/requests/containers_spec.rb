require 'rails_helper'

describe "Pages API" do

  before do
    @layout = create :layout
    @page = create :page, layout: @layout, sections: [:billboard_section, :cars_section]
    @project = create :project
  end

  let(:page_url) { "/pages/#{@page.id}" }
  let(:layout_url) { "/layouts/#{@layout.id}" }

  describe "listing containers" do
    shared_examples "a container list" do |container_type, container_class|
      let(:url) { "/#{container_type.to_s.pluralize}" }

      before do
        create_list :page, 5
        create :layout
      end

      it "should return the correct number of containers" do
        get url
        expect(response).to be_success
        expect(json["containers"].size).to eq container_class.count
      end

      it "should include the id for each container" do
        get url

        json["containers"].each do |container|
          expect(container).to have_key "id"
        end
      end

      it "should include the url, name, locale and published from the current_revision" do
        get url

        json["containers"].each do |container|
          expect(container["currentRevision"]).to have_key "url"
          expect(container["currentRevision"]).to have_key "published"
          expect(container["currentRevision"]).to have_key "locale"
          expect(container["currentRevision"]).to have_key "name"
        end
      end

      it "should only include #{container_class} instances" do
        get url

        json["containers"].each do |page|
          expect(page["type"]).to eq container_class.name.demodulize
        end
      end
    end

    it_should_behave_like "a container list", :page, Ninetails::Page
    it_should_behave_like "a container list", :layout, Ninetails::Layout
  end

  describe "showing containers" do
    shared_examples "a container detail" do |container_type, container_class|
      if container_type == :page
        let(:url) { page_url }
        let(:container) { @page }
      else
        let(:url) { layout_url }
        let(:container) { @layout }
      end

      describe "when not specifying revision" do
        describe "when the container exists" do
          before do
            get url
            expect(response).to be_success
          end

          it "should return the current revision of a page" do
            expect(json["container"]["currentRevision"]["id"]).to eq container.current_revision.id
          end

          it "should return a container with type #{container_class}" do
            expect(json["container"]["type"]).to eq container_class.name.demodulize
          end

          if container_type == :page
            it "should include the container's sections" do
              expect(json["container"]["currentRevision"]["sections"].size).to eq 2
            end

            it "should include section data" do
              expect(json["container"]["currentRevision"]["sections"][1]["data"]).to have_key "cars"
            end

            it "should include the page layout nested in a layout key" do
              expect(json["container"]["layout"]["container"]["id"]).to eq @layout.id
              expect(json["container"]["layout"]["container"]["type"]).to eq "Layout"
            end

            it "should include the revision's published attribute" do
              expect(json["container"]["currentRevision"]["published"]).to eq container.current_revision.published
            end

            it "should include the revision's url attribute" do
              expect(json["container"]["currentRevision"]["url"]).to eq container.current_revision.url
            end
          else
            it "should not include a layout key" do
              expect(json["container"]).not_to have_key "layout"
            end

            it "should not include a published attribute" do
              expect(json["container"]["currentRevision"]).not_to have_key "published"
            end

            it "should not include a url attribute" do
              expect(json["container"]["currentRevision"]).not_to have_key "url"
            end
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

    it_should_behave_like "a container detail", :page, Ninetails::Page
    it_should_behave_like "a container detail", :layout, Ninetails::Layout
  end

  describe "projects" do
    shared_examples "a container in a project" do |container_type|
      before do
        @containers = create_list container_type, 5
        @other_page = create :page

        @containers.each do |container|
          create :revision, container: container, project: @project
        end
      end

      let(:url) { "/projects/#{@project.id}/#{container_type.to_s.pluralize}" }

      describe "when listing containers" do
        it "should return the number of containers which belong to the project" do
          get url
          expect(json["containers"].length).to eq @containers.length
        end

        it "should not include containers which have not been changed in this project" do
          get url
          expect(json["containers"].collect { |p| p["id"] }).not_to include @other_page.id
        end

        it "should be successfull if the project exists" do
          get url
          expect(response).to be_success
        end

        it "should raise an error if the project does not exist" do
          get "/projects/foo/#{container_type.to_s.pluralize}"
          expect(response).to_not be_success
        end

        it "should include the url and published from the current_revision" do
          get url

          json["containers"].each do |container|
            expect(container["currentRevision"]).to have_key "url"
            expect(container["currentRevision"]).to have_key "published"
          end
        end

        it "should include the url and published from the project revision" do
          get url

          json["containers"].each do |container|
            expect(container["revision"]).to have_key "url"
            expect(container["revision"]).to have_key "published"
          end
        end
      end

      describe "when showing a container" do
        let(:project_container) { @project.project_containers.first }

        it "should use the current project container to fetch the latest revision" do
          get "#{url}/#{project_container.container_id}"
          expect(json["container"]["revision"]["id"]).to eq project_container.revision_id
        end
      end

      describe "when creating a container" do
        let(:valid_container_params) do
          {
            container: {}
          }
        end

        it "should create a new ProjectContainer" do
          expect {
            post url, params: valid_container_params
          }.to change{ Ninetails::ProjectContainer.count }.by(1)
        end

        it "should set the ProjectContainer to belong to the project and the container" do
          post url, params: valid_container_params
          project_container = Ninetails::ProjectContainer.last
          expect(project_container.project_id).to eq @project.id
          expect(project_container.container_id).to eq json["container"]["id"]
        end
      end
    end

    it_should_behave_like "a container in a project", :page
    it_should_behave_like "a container in a project", :layout
  end

  describe "creating containers" do
    shared_examples "creating a container" do |container_type, container_class|
      let(:url) { "/#{container_type.to_s.pluralize}" }

      let(:valid_container_params) do
        {
          container: {}
        }
      end

      it "should save the container if it is valid" do
        expect {
          post url, params: valid_container_params
        }.to change{ container_class.count }.by(1)
      end

      it "should have a blank revision id" do
        post url, params: valid_container_params
        expect(json["container"]["currentRevision"]["id"]).to be_nil
      end

      it "should have an empty sections array" do
        post url, params: valid_container_params
        expect(json["container"]["currentRevision"]["sections"]).to eq []
      end

      it "should create a project container if in the project scope" do
        expect {
          post "/projects/#{@project.id}#{url}", params: valid_container_params
        }.to change{ @project.containers.count }.by(1)
      end
    end

    it_should_behave_like "creating a container", :page, Ninetails::Page
    it_should_behave_like "creating a container", :layout, Ninetails::Layout
  end

  describe "controlling the current revision" do
    shared_examples "a container with a default revision" do |container_type, container_class|
      let(:container) { container_type == :page ? @page : @layout }
      let(:url) { container_type == :page ? page_url : layout_url }

      describe "when the container exists" do
        it "should return the current revision of a container" do
          get url

          expect(response).to be_success
          expect(json["container"]["currentRevision"]["id"]).to eq container.current_revision.id
        end
      end

      describe "when the container does not exist" do
        it "should return a 404 if the id doesn't exist" do
          get "/#{container_type.to_s.pluralize}/0"
          expect(response).to be_not_found
        end
      end
    end

    it_should_behave_like "a container with a default revision", :page, Ninetails::Page
    it_should_behave_like "a container with a default revision", :layout, Ninetails::Layout

    shared_examples "a container with a specified revision" do |container_type, container_class|
      let(:container) { container_type == :page ? @page : @layout }
      let(:url) { container_type == :page ? page_url : layout_url }

      describe "when the container and revision exist" do
        it "should return the specified revision of the container when using the url to fetch the container" do
          new_revision = create :revision
          container.revisions << new_revision

          get "#{url}?revision_id=#{new_revision.id}"

          expect(response).to be_success
          expect(json["container"]["revision"]["id"]).not_to eq json["container"]["currentRevision"]["id"]
          expect(json["container"]["revision"]["id"]).to eq new_revision.id
          expect(json["container"]["revision"]["id"]).not_to eq container.current_revision.id
        end

        it "should return the specified revision of the container when using the id to fetch the container" do
          new_revision = create :revision
          container.revisions << new_revision

          get "#{url}?revision_id=#{new_revision.id}"

          expect(response).to be_success
          expect(json["container"]["revision"]["id"]).not_to eq json["container"]["currentRevision"]["id"]
          expect(json["container"]["revision"]["id"]).to eq new_revision.id
          expect(json["container"]["revision"]["id"]).not_to eq container.current_revision.id
        end
      end

      describe "when the container does not exist" do
        it "should return a 404" do
          get "/#{container_type.to_s.pluralize}/nil"

          expect(response).to be_not_found
        end
      end

      describe "when the container exists, but the revision does not" do
        it "should return a 404" do
          get "#{url}?revision_id=bogus"

          expect(response).to be_not_found
        end
      end

      describe "when the container and revision exist, but are not related" do
        it "should return a 404" do
          revision = create :revision
          get "#{url}?revision_id=#{revision.id}"

          expect(response).to be_not_found
        end
      end
    end

    it_should_behave_like "a container with a specified revision", :page, Ninetails::Page
  end

  describe "destroying a container" do
    shared_examples "a destroyable container" do |container_type, container_class|
      describe "when the container exists" do
        before do
          @container = create container_type
          @url = "/#{container_type.to_s.pluralize}/#{@container.id}"
        end

        it "should soft delete the container" do
          expect {
            delete @url
          }.not_to change{ container_class.with_deleted.count }

          expect(@container.reload.deleted_at).not_to be nil
        end

        it "should not remove revisions" do
          expect {
            delete @url
          }.not_to change{ Ninetails::Revision.count }
        end
      end

      describe "when the container does not exist" do
        it "should return a 404" do
          delete "/pages/0"
          expect(response).to be_not_found
        end
      end
    end

    it_should_behave_like "a destroyable container", :page, Ninetails::Page
    it_should_behave_like "a destroyable container", :layout, Ninetails::Layout
  end

end
