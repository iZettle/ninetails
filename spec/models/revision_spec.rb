require 'rails_helper'

RSpec.describe Ninetails::Revision, type: :model do

  it { should belong_to(:container) }
  it { should belong_to(:project) }
  it { should have_many(:revision_sections) }
  it { should have_many(:sections).order(:created_at) }
  
  it "should not be published by default" do
    expect(Ninetails::Revision.new.published).to eq false
  end

  describe "when the container is a Page" do
    subject  { create :revision, container: create(:page) }
    
    it { should validate_presence_of(:url) }
  end
  
  describe "when the container is a Layout" do
    subject  { create :revision, container: create(:layout) }

    it { should_not validate_presence_of(:url) }
  end

end
