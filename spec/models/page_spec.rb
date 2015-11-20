require 'rails_helper'

RSpec.describe Ninetails::Page, type: :model do

  describe "building json" do

    let(:page) { create :page }
    let(:json) do
      {
        page: {
          id: page.id,
          name: page.name,
          url: page.url,
          revisionId: page.revision.id,
          sections: page.sections_to_builder
        }
      }.to_json
    end

    it "should build the page into json" do
      expect(page.to_builder.target!).to eq json
    end

  end

end
