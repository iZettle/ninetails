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

  describe "validations" do

    it "should require a url" do
      new_page = Ninetails::Page.new url: nil
      expect(new_page.valid?).to be false
      expect(new_page.errors[:url]).to eq ["can't be blank"]
    end

    it "should require a unique url" do
      new_page = Ninetails::Page.new url: create(:page).url
      expect(new_page.valid?).to be false
      expect(new_page.errors[:url]).to eq ["has already been taken"]
    end

  end

end
