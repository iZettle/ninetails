require 'rails_helper'

describe "Page Revisions API" do

  let(:page) { create :page_with_revisions, revisions_count: 5 }

  describe "listing revisions" do
    describe "with a valid page_id" do

      before do
        get "/pages/#{page.id}/revisions"
      end

      it "should list the revisions which belong to that page" do
        expect(response).to be_success
        expect(json["revisions"].size).to eq 5
      end

    end
  end

  describe "creating a revision" do
    let(:valid_revision_params) do
      {
        "page_revision": {
          "message": "",
          "sections":[
            document_head_section
          ]
        }
      }
    end

    let(:invalid_revision_params) do
      {
        "page_revision": {
          "message": "",
          "sections":[
            document_head_section(title: "", description: "")
          ]
        }
      }
    end

    let(:project) { create :project }
    let(:valid_revision_params_with_project) do
      {
        "page_revision": {
          "message": "",
          "sections":[
            document_head_section
          ],
          "project_id": project.id
        }
      }
    end

    describe "with valid sections and a project id" do
      it "should create a revision with the project id" do
        expect {
          post "/pages/#{page.id}/revisions", valid_revision_params_with_project
        }.to change { page.revisions.count }.by(1)

        expect(response).to be_success
        expect(Ninetails::PageRevision.find(json["page"]["revisionId"]).project).to eq project
      end

      it "should create a new ProjectPage entry if one doesn't exist for this page in the project" do
        expect {
          post "/pages/#{page.id}/revisions", valid_revision_params_with_project
        }.to change { Ninetails::ProjectPage.count }.by(1)

        revision = Ninetails::PageRevision.find json["page"]["revisionId"]
        project_page = Ninetails::ProjectPage.last
        expect(project_page.page).to eq page
        expect(project_page.project).to eq project
        expect(project_page.page_revision).to eq revision
      end

      it "should modify an existing ProjectPage entry if one exists for this page in the project" do
        project_page = create :project_page, page: page, project: project

        expect {
          post "/pages/#{page.id}/revisions", valid_revision_params_with_project
        }.to_not change { Ninetails::ProjectPage.count }

        revision = Ninetails::PageRevision.find json["page"]["revisionId"]
        project_page = Ninetails::ProjectPage.last
        expect(project_page.page).to eq page
        expect(project_page.project).to eq project
        expect(project_page.page_revision).to eq revision
      end
    end

    describe "with valid sections" do
      it "should create a revision" do
        expect {
          post "/pages/#{page.id}/revisions", valid_revision_params
        }.to change { page.revisions.count }.by(1)

        expect(response).to be_success
        expect(json["page"]["revisionId"]).to_not be_nil
      end

      it "should have created the correct number of sections" do
        post "/pages/#{page.id}/revisions", valid_revision_params
        expect(page.revisions.last.sections.size).to eq 1
      end
    end

    describe "with invalid sections" do
      it "should not create a revision" do
        expect {
          post "/pages/#{page.id}/revisions", invalid_revision_params
        }.not_to change { page.revisions.count }
      end

      it "should show error messages in the revision params" do
        post "/pages/#{page.id}/revisions", invalid_revision_params

        errors = json["page"]["sections"][0]["elements"]["title"]["content"]["errors"]
        expect(errors).to eq({ "text"=>["can't be blank"] })
      end
    end
  end

  describe "handling hash keys in camelcase" do

    let(:camelcased_revision) do
      {
        page_revision: {
          message: "",
          sections: [
            {
              "name": "",
              "type": "MinimalBillboard",
              "tags": {
                "position": "body"
              },
              "elements": {
                "backgroundImage": {
                  "type": "Figure",
                  "image": {
                    "src": "/foobar.jpg",
                    "alt": "Hello world"
                  }
                }
              }
            }
          ]
        }
      }
    end

    it "should not cause problems" do
      expect {
        post "/pages/#{page.id}/revisions", camelcased_revision
      }.to change { page.revisions.count }.by(1)

      expect(response).to be_success
      expect(json["page"]["revisionId"]).to_not be_nil
    end

  end

end
