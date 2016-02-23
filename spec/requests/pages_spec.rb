require 'rails_helper'

describe "Pages API" do

  let(:project) { create :project }
  let(:page) { create :page }
  let(:page_url) { "/pages/#{CGI.escape(page.url)}" }
  let(:page_url_from_id) { "/pages/#{page.id}" }

  describe "listing pages" do
    before do
      create_list :page, 5
    end

    it "should return the correct number of pages" do
      get "/pages"
      expect(response).to be_success
      expect(json["pages"].size).to eq Ninetails::Page.count
    end

    it "should include the id and url for each page" do
      get "/pages"

      json["pages"].each do |page|
        expect(page).to have_key "id"
        expect(page).to have_key "url"
      end
    end
  end

  describe "projects" do
    before do
      @project_pages = create_list :page, 5
      @other_page = create :page

      @project_pages.each do |page|
        create :page_revision, page: page, project: project
      end
    end

    describe "when listing pages" do
      it "should return the number of pages which belong to the project" do
        get "/projects/#{project.id}/pages"
        expect(json["pages"].length).to eq @project_pages.length
      end

      it "should not include pages which have not been changed in this project" do
        get "/projects/#{project.id}/pages"
        expect(json["pages"].collect { |p| p["id"] }).not_to include @other_page.id
      end

      it "should be successfull if the project exists" do
        get "/projects/#{project.id}/pages"
        expect(response).to be_success
      end

      it "should raise an error if the project does not exist" do
        get "/projects/foo/pages"
        expect(response).to_not be_success
      end
    end

    describe "when showing a page" do
      let(:project_page) { project.project_pages.first }

      it "should use the current project page to fetch the latest revision" do
        get "/projects/#{project.id}/pages/#{project_page.page_id}"
        expect(json["page"]["revisionId"]).to eq project_page.page_revision_id
      end
    end
  end

  describe "creating a page" do

    let(:valid_page_params) do
      {
        page: {
          name: "A new page",
          url: "/foobar"
        }
      }
    end

    let(:existing_page_url_params) do
      {
        page: {
          name: "An existing page",
          url: page.url
        }
      }
    end

    it "should save the page if it is valid" do
      expect {
        post "/pages", valid_page_params
      }.to change{ Ninetails::Page.count }.by(1)
    end

    it "should show errors if the url is taken" do
      post "/pages", existing_page_url_params

      expect(response).to_not be_success
      expect(json["page"]["errors"]["url"]).not_to be_empty
    end

    it "should have a blank revision id" do
      post "/pages", valid_page_params
      expect(json["page"]["revisionId"]).to be_nil
    end

    it "should have an empty sections array" do
      post "/pages", valid_page_params
      expect(json["page"]["sections"]).to eq []
    end

    it "should create a project page if in the project scope" do
      expect {
        post "/projects/#{project.id}/pages", valid_page_params
      }.to change{ project.pages.count }.by(1)
    end

  end

  describe "when not specifying revision" do
    describe "when the page exists" do
      it "should return the current revision of a page when using the url to fetch the page" do
        get page_url

        expect(response).to be_success
        expect(json["page"]["revisionId"]).to eq page.current_revision.id
      end

      it "should return the current revision of a page when using the id to fetch the page" do
        get page_url_from_id

        expect(response).to be_success
        expect(json["page"]["revisionId"]).to eq page.current_revision.id
      end
    end

    describe "when the page does not exist" do
      it "should return a 404 if the url doesn't exist" do
        get "/pages/nil"
        expect(response).to be_not_found
      end

      it "should return a 404 if the id doesn't exist" do
        get "/pages/0"
        expect(response).to be_not_found
      end
    end
  end

  describe "when specifying a revision" do
    describe "when the page and revision exist" do
      it "should return the specified revision of the page when using the url to fetch the page" do
        new_revision = create :page_revision
        page.revisions << new_revision

        get "#{page_url}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["page"]["revisionId"]).to eq new_revision.id
        expect(json["page"]["revisionId"]).not_to eq page.current_revision.id
      end

      it "should return the specified revision of the page when using the id to fetch the page" do
        new_revision = create :page_revision
        page.revisions << new_revision

        get "#{page_url_from_id}?revision_id=#{new_revision.id}"

        expect(response).to be_success
        expect(json["page"]["revisionId"]).to eq new_revision.id
        expect(json["page"]["revisionId"]).not_to eq page.current_revision.id
      end
    end

    describe "when the page does not exist" do
      it "should return a 404" do
        get "/pages/nil"

        expect(response).to be_not_found
      end
    end

    describe "when the page exists, but the revision does not" do
      it "should return a 404" do
        get "#{page_url}?revision_id=bogus"

        expect(response).to be_not_found
      end
    end

    describe "when the page and revision exist, but are not related" do
      it "should return a 404" do
        revision = create :page_revision
        get "#{page_url}?revision_id=#{revision.id}"

        expect(response).to be_not_found
      end
    end
  end

end
