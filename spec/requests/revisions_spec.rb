require 'rails_helper'

describe "Revisions API" do

  let(:container) { create :container_with_revisions, revisions_count: 5 }

  describe "listing revisions" do
    describe "with a valid container_id" do

      before do
        get "/containers/#{container.id}/revisions"
      end

      it "should list the revisions which belong to that container" do
        expect(response).to be_success
        expect(json["revisions"].size).to eq 5
      end

      it "should include sections in the revision" do
        expect(json["revisions"][0]).to have_key "sections"
      end
    end
  end

  describe "creating a revision" do
    let(:valid_revision_params) do
      {
        "revision": {
          "message": "",
          "sections":[
            document_head_section
          ]
        }
      }
    end

    let(:invalid_revision_params) do
      {
        "revision": {
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
        "revision": {
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
          post "/containers/#{container.id}/revisions", valid_revision_params_with_project
        }.to change { container.revisions.count }.by(1)

        expect(response).to be_success
        expect(Ninetails::Revision.find(json["container"]["revisionId"]).project).to eq project
      end

      it "should create a new Project Revision entry if one doesn't exist for this container in the project" do
        expect {
          post "/containers/#{container.id}/revisions", valid_revision_params_with_project
        }.to change { Ninetails::ProjectContainer.count }.by(1)

        revision = Ninetails::Revision.find json["container"]["revisionId"]
        project_container = Ninetails::ProjectContainer.last
        expect(project_container.container).to eq container
        expect(project_container.project).to eq project
        expect(project_container.revision).to eq revision
      end

      it "should modify an existing ProjectContainer entry if one exists for this container in the project" do
        project_container = create :project_container, container: container, project: project

        expect {
          post "/containers/#{container.id}/revisions", valid_revision_params_with_project
        }.to_not change { Ninetails::ProjectContainer.count }

        revision = Ninetails::Revision.find json["container"]["revisionId"]
        project_container = Ninetails::ProjectContainer.last
        expect(project_container.container).to eq container
        expect(project_container.project).to eq project
        expect(project_container.revision).to eq revision
      end
    end

    describe "with valid sections" do
      it "should create a revision" do
        expect {
          post "/containers/#{container.id}/revisions", valid_revision_params
        }.to change { container.revisions.count }.by(1)

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to_not be_nil
      end

      it "should have created the correct number of sections" do
        post "/containers/#{container.id}/revisions", valid_revision_params
        expect(container.revisions.last.sections.size).to eq 1
      end
    end

    describe "with invalid sections" do
      it "should not create a revision" do
        expect {
          post "/containers/#{container.id}/revisions", invalid_revision_params
        }.not_to change { container.revisions.count }
      end

      it "should show error messages in the revision params" do
        post "/containers/#{container.id}/revisions", invalid_revision_params

        errors = json["container"]["sections"][0]["elements"]["title"]["content"]["errors"]
        expect(errors).to eq({ "text"=>["can't be blank"] })
      end
    end
  end

  describe "handling hash keys in camelcase" do

    let(:camelcased_revision) do
      {
        revision: {
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
        post "/containers/#{container.id}/revisions", camelcased_revision
      }.to change { container.revisions.count }.by(1)

      expect(response).to be_success
      expect(json["container"]["revisionId"]).to_not be_nil
    end

  end

end
