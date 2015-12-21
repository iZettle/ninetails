require 'rails_helper'

RSpec.describe Ninetails::Page, type: :model do

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
