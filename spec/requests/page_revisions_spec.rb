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
            {
              "name": "",
              "type": "DocumentHead",
              "tags": {
                "position": "head"
              },
              "elements": {
                "title": {
                  "type": "Text",
                  "content": {
                    "text": "iZettle – Accept credit card payments with your iPhone, iPad or Android"
                  }
                },
                "description": {
                  "type": "Meta",
                  "content": {
                    "text": "Accept credit card payments on the go with iZettle. All you need is a smartphone or a tablet and our free app."
                  }
                }
              }
            }
          ]
        }
      }
    end

    let(:invalid_revision_params) do
      {
        "page_revision": {
          "message": "",
          "sections":[
            {
              "name": "",
              "type": "DocumentHead",
              "tags": {
                "position": "head"
              },
              "elements": {
                "title": {
                  "type": "Text",
                  "content": {
                    "text": ""
                  }
                },
                "description": {
                  "type": "Meta",
                  "content": {
                    "text": ""
                  }
                }
              }
            }
          ]
        }
      }
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
