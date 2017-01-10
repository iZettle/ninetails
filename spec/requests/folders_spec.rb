require "rails_helper"

describe "Folders API" do

  describe "listing folders" do
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

  describe "creating a folder" do
    it "should persist a new folder with valid params" do
      expect {
        post "/folders", params: { folder: { name: "A new folder" }}
      }.to change{ Ninetails::Folder.count }.by(1)

      expect(response).to be_success
    end

    it "should show errors if the folder was invalid" do
      expect {
        post "/folders", params: { folder: { name: "" }}
      }.not_to change{ Ninetails::Folder.count }

      expect(response).not_to be_success
      expect(json["folder"]).to have_key "errors"
    end
  end

  describe "updating a folder" do
    before do
      @folder = create :folder
    end

    it "should save the changes if they were valid" do
      expect {
        put "/folders/#{@folder.id}", params: { folder: { name: "A new name" }}
      }.to change{ @folder.reload.name }.from(@folder.name).to("A new name")

      expect(response).to be_success
    end

    it "should not save the changes if they were invalid" do
      expect {
        put "/folders/#{@folder.id}", params: { folder: { name: "" }}
      }.not_to change{ @folder.reload.name }

      expect(response).not_to be_success
      expect(json["folder"]).to have_key "errors"
    end
  end

  describe "destroying folders" do
    it "should soft delete the folder" do
      folder = create :folder
      expect {
        delete "/folders/#{folder.id}"
      }.not_to change{ Ninetails::Folder.with_deleted.count }

      expect(folder.reload.deleted_at).not_to be nil
    end
  end

  describe "showing a folder" do
    before do
      @folder = create :folder
      @pages = create_list :page, 2, folder: @folder
      @second_revision = create :revision, container: @pages.first, folder: @folder
    end

    it "should include info about the folder" do
      get "/folders/#{@folder.id}"
      expect(response).to be_success

      expect(json["folder"]["id"]).to eq @folder.id
      expect(json["folder"]["name"]).to eq @folder.name
    end

    it "should include some info about each revision" do
      get "/folders/#{@folder.id}"

      expect(json["folder"]["revisions"].length).to eq 2
      expect(json["folder"]["revisions"][0]["id"]).to eq @pages[0].current_revision.id
      expect(json["folder"]["revisions"][0]["url"]).to eq @pages[0].current_revision.url

      expect(json["folder"]["revisions"][1]["id"]).to eq @pages[1].current_revision.id
      expect(json["folder"]["revisions"][1]["url"]).to eq @pages[1].current_revision.url
    end
  end

end
