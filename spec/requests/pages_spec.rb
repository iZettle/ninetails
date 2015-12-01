require 'rails_helper'

describe "Pages API" do

  let(:page) { create :page }
  let(:page_url) { "/pages/#{CGI.escape(page.url)}" }

  describe "creating a page" do

    let(:valid_page_params) do
      {
        page: {
          url: "/foobar"
        }
      }
    end

    let(:existing_page_url_params) do
      {
        page: {
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

  end

  describe "when not specifying revision" do
    describe "when the page exists" do
      it "should return the current revision of a page" do
        get page_url

        expect(response).to be_success
        expect(response.body).to eq page.to_builder.target!
        expect(json["page"]["revisionId"]).to eq page.current_revision.id
      end
    end

    describe "when the page does not exist" do
      it "should return a 404" do
        get "/pages/nil"

        expect(response).to be_not_found
      end
    end
  end

  describe "when specifying a revision" do
    describe "when the page and revision exist" do
      it "should return the specified revision of the page" do
        new_revision = create :page_revision
        page.revisions << new_revision

        get "#{page_url}?revision_id=#{new_revision.id}"

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
