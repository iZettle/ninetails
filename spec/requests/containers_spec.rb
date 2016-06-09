require 'rails_helper'

describe "Pages API" do

  before do
    @layout = create :layout
    @page = create :page, layout: @layout
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

      it "should include the id and url for each container" do
        get url

        json["containers"].each do |container|
          expect(container).to have_key "id"

          if container_type == :page
            expect(container).to have_key "url"
          else
            expect(container).not_to have_key "url"
          end
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
            expect(json["container"]["revisionId"]).to eq container.current_revision.id
          end

          it "should return a container with type #{container_class}" do
            expect(json["container"]["type"]).to eq container_class.name.demodulize
          end

          if container_type == :page
            it "should include the page layout nested in a layout key" do
              expect(json["container"]["layout"]["container"]["id"]).to eq @layout.id
              expect(json["container"]["layout"]["container"]["type"]).to eq "Layout"
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
      end

      describe "when showing a container" do
        let(:project_container) { @project.project_containers.first }

        it "should use the current project container to fetch the latest revision" do
          get "#{url}/#{project_container.container_id}"
          expect(json["container"]["revisionId"]).to eq project_container.revision_id
        end

        it "should use the 'live' container when the container doesn't exist in the project scope" do
          new_container = create container_type, :with_a_revision
          get "#{url}/#{new_container.id}"
          expect(json["container"]["revisionId"]).to eq new_container.revision.id
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
          container: {
            name: "A new container",
            url: "/foobar",
            locale: "en_US"
          }
        }
      end

      let(:existing_page_url_params) do
        {
          container: {
            name: "An existing container",
            url: @page.url,
            locale: "en_US"
          }
        }
      end

      let(:page_with_no_locale_params) do
        {
          container: {
            name: "A container",
            url: "/no-locale"
          }
        }
      end

      it "should save the container if it is valid" do
        expect {
          post url, valid_container_params
        }.to change{ container_class.count }.by(1)
      end

      if container_type == :page
        it "should show errors if the url is taken" do
          post url, existing_page_url_params

          expect(response).to_not be_success
          expect(json["container"]["errors"]["url"]).not_to be_empty
        end
      end

      it "should require a locale" do
        post url, page_with_no_locale_params

        expect(response).to_not be_success
        expect(json["container"]["errors"]["locale"]).not_to be_empty
      end

      it "should have a blank revision id" do
        post url, valid_container_params
        expect(json["container"]["revisionId"]).to be_nil
      end

      it "should have an empty sections array" do
        post url, valid_container_params
        expect(json["container"]["sections"]).to eq []
      end

      it "should create a project container if in the project scope" do
        expect {
          post "/projects/#{@project.id}#{url}", valid_container_params
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
          expect(json["container"]["revisionId"]).to eq container.current_revision.id
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
          expect(json["container"]["revisionId"]).to eq new_revision.id
          expect(json["container"]["revisionId"]).not_to eq container.current_revision.id
        end

        it "should return the specified revision of the container when using the id to fetch the container" do
          new_revision = create :revision
          container.revisions << new_revision

          get "#{url}?revision_id=#{new_revision.id}"

          expect(response).to be_success
          expect(json["container"]["revisionId"]).to eq new_revision.id
          expect(json["container"]["revisionId"]).not_to eq container.current_revision.id
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

end
