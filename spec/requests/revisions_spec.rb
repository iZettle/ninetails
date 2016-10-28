require 'rails_helper'

describe "Revisions API" do

  let(:page) { create :page, :with_revisions, revisions_count: 5 }

  describe "listing revisions" do
    describe "with a valid page_id" do

      before do
        get "/pages/#{page.id}/revisions"
      end

      it "should list the revisions which belong to that page" do
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
        revision: {
          url: build(:revision).url,
          sections: [
            document_head_section
          ]
        }
      }
    end

    # TODO - test dupe url

    let(:valid_revision_params_with_extra_keys) do
      {
        revision: {
          url: build(:revision).url,
          sections: [
            document_head_section.merge({ "located_in" => "body", "location_name" => "foobar" })
          ]
        }
      }
    end

    let(:invalid_revision_params) do
      {
        revision: {
          sections: [
            document_head_section(title: "", description: "")
          ]
        }
      }
    end

    let(:project) { create :project }
    let(:valid_revision_params_with_project) do
      {
        revision: {
          url: build(:revision).url,
          project_id: project.id,
          sections: [
            document_head_section
          ]
        }
      }
    end

    let(:valid_revision_params_with_variant) do
      {
        revision: {
          url: build(:revision).url,
          sections: [
            document_head_section(variant: "extended")
          ]
        }
      }
    end

    describe "with valid sections and a project id" do
      it "should create a revision with the project id" do
        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params_with_project
        }.to change { page.revisions.count }.by(1)

        expect(response).to be_success
        expect(Ninetails::Revision.find(json["container"]["revisionId"]).project).to eq project
      end

      it "should create a new Project Revision entry if one doesn't exist for this page in the project" do
        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params_with_project
        }.to change { Ninetails::ProjectContainer.count }.by(1)

        revision = Ninetails::Revision.find json["container"]["revisionId"]
        project_container = Ninetails::ProjectContainer.last
        expect(project_container.container).to eq page
        expect(project_container.project).to eq project
        expect(project_container.revision).to eq revision
      end

      it "should modify an existing ProjectContainer entry if one exists for this page in the project" do
        project_container = create :project_container, :with_revision, container: page, project: project

        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params_with_project
        }.to_not change { Ninetails::ProjectContainer.count }

        revision = Ninetails::Revision.find json["container"]["revisionId"]
        project_container = Ninetails::ProjectContainer.last
        expect(project_container.container).to eq page
        expect(project_container.project).to eq project
        expect(project_container.revision).to eq revision
      end
    end

    describe "with valid sections" do
      it "should create a revision" do
        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params
        }.to change { page.revisions.count }.by(1)

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to_not be_nil
      end

      it "should have created the correct number of sections" do
        post "/pages/#{page.id}/revisions", params: valid_revision_params
        expect(page.revisions.last.sections.size).to eq 1
      end
    end

    describe "with valid sections and a variant" do
      it "should create a revision" do
        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params_with_variant
        }.to change { page.revisions.count }.by(1)

        expect(response).to be_success
        expect(json["container"]["revisionId"]).to_not be_nil
      end

      it "should have stored the variant" do
        post "/pages/#{page.id}/revisions", params: valid_revision_params_with_variant
        expect(page.revisions.last.sections.first.variant).to eq "extended"
      end
    end

    describe "with invalid sections" do
      it "should not create a revision" do
        expect {
          post "/pages/#{page.id}/revisions", params: invalid_revision_params
        }.not_to change { page.revisions.count }
      end

      it "should show error messages in the revision params" do
        post "/pages/#{page.id}/revisions", params: invalid_revision_params

        errors = json["container"]["sections"][0]["elements"]["title"]["content"]["errors"]
        expect(errors).to eq({ "text"=>["can't be blank"] })
      end
    end

    describe "when providing extra keys in the json" do
      it "should not blow up" do
        expect {
          post "/pages/#{page.id}/revisions", params: valid_revision_params_with_extra_keys
        }.not_to raise_error
      end
    end
  end

  describe "handling hash keys in camelcase" do
    before do
      Ninetails::Config.key_style = :camelcase
    end

    after do
      Ninetails::Config.key_style = :underscore
    end

    let(:camelcased_revision) do
      {
        revision: {
          url: build(:revision).url,
          sections: [
            {
              "name": "",
              "type": "LongNameSection",
              "elements": {
                "longNameElement": {
                  "type": "LongNameElement",
                  "longNameProperty": {
                    "longTextString": "foo"
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
        post "/pages/#{page.id}/revisions", params: camelcased_revision
      }.to change { page.revisions.count }.by(1)

      expect(response).to be_success
      expect(json["container"]["revisionId"]).to_not be_nil
      expect(json["container"]["sections"][0]["elements"]["longNameElement"]["longNameProperty"]["longTextString"]).to_not be_nil
    end

  end

end
