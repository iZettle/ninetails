require 'rails_helper'

RSpec.describe Ninetails::Revision, type: :model do

  it { should belong_to(:container) }
  it { should belong_to(:project) }
  it { should have_many(:revision_sections) }
  it { should have_many(:sections).order(:created_at) }
  
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
      it "requires a unique url for Page revisions" do
        revision = Ninetails::Revision.new container: @page, url: "/foo"
        revision.valid?
        expect(revision.errors[:url]).to eq ["has already been taken"]
      end
    end
  end

end
