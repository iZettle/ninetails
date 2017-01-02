require "rails_helper"

describe "Folders API" do

  describe "listing folder" do
    before do
      @folders = create_list :folder, 5
    end

    it "should return all folders" do
      get "/folders"
      expect(json["folders"].size).to eq 5
      expect(json["folders"].first["name"]).to eq @folders.first.name
    end

    it "should not include deleted folders" do
      @folders.first.delete
      get "/folders"
      expect(json["folders"].size).to eq 4
      expect(json["folders"].first["name"]).not_to eq @folders.first.name
    end

  end

end
