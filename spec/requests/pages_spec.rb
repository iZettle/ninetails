require 'rails_helper'

describe "Pages API" do

  before do
    @layout = create :layout
    @page = create :page, layout: @layout
  end

  let(:page_url) { "/pages/#{@page.id}" }

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

        it "should return a container with type Ninetails::Page" do
          expect(json["container"]["type"]).to eq "Ninetails::Page"
        end

        it "should include the page layout nested in a layout key" do
          expect(json["container"]["layout"]["container"]["id"]).to eq @layout.id
          expect(json["container"]["layout"]["container"]["type"]).to eq "Ninetails::Layout"
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

end
