require 'rails_helper'

RSpec.describe Ninetails::Revision, type: :model do

  it { should belong_to(:container) }
  it { should belong_to(:project) }
  it { should belong_to(:folder) }
  it { should have_many(:revision_sections) }
  it { should have_many(:sections).order(:created_at) }

  it { should validate_presence_of(:locale) }

  it "should not be published by default" do
    expect(Ninetails::Revision.new.published).to eq false
  end

  describe "validating urls" do
    before do
      # Seed with some things to check uniqueness against
      @page = create :page
      @layout = create :layout
      create :revision, container: @page, url: nil
      create :revision, container: @page, url: "/foo"
    end

    describe "when the url is blank" do
      it "doesn't require a url for Layout revisions" do
        revision = Ninetails::Revision.new container: @layout, url: nil
        revision.valid?
        expect(revision.errors[:url]).to eq []
      end

      it "doesn't require a url for Page revisions" do
        revision = Ninetails::Revision.new container: @page, url: nil
        revision.valid?
        expect(revision.errors[:url]).to eq []
      end
    end

    describe "when the url is present" do
      it "doesn't allow the url to be used for different containers" do
        page = create(:page)
        revision = create :revision, container: page, url: "/foo"
        page.update_attributes current_revision: revision

        revision = Ninetails::Revision.new container: create(:page), url: "/foo"
        revision.valid?
        expect(revision.errors[:url]).to eq ["is already in use"]
      end

      it "allows the same url to be used on different containers if it is not the current_revision" do
        revision = Ninetails::Revision.new container: create(:page), url: "/foo"
        revision.valid?
        expect(revision.errors[:url]).to eq []
      end

      it "allows the same url to be used for the same container multiple times" do
        revision = Ninetails::Revision.new container: @page, url: "/foo"
        revision.valid?
        expect(revision.errors[:url]).to eq []
      end
    end
  end

end
