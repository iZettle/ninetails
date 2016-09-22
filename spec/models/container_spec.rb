require 'rails_helper'

RSpec.describe Ninetails::Container, type: :model do

  it { should have_many(:revisions) }
  it { should have_many(:project_containers) }
  it { should have_one(:current_revision) }

  it { should validate_presence_of(:locale) }

  describe ".find_and_load_revision" do
    before do
      @page = create :page, :with_revisions
      @layout = create :layout
      @project = create :project
      @project_container = create :project_container, :with_revision, project: @project, container: @page
    end

    it "should find a page by id" do
      expect(Ninetails::Container.find_and_load_revision(id: @page.id)).to eq @page
    end

    it "should find a page by url" do
      expect(Ninetails::Container.find_and_load_revision(id: @page.url)).to eq @page
    end

    it "should find a layout by id" do
      expect(Ninetails::Container.find_and_load_revision(id: @layout.id)).to eq @layout
    end

    describe "setting the revision using an id" do
      before do
        @modified_page = Ninetails::Container.find_and_load_revision id: @page.id, revision_id: @page.revisions[1].id
      end

      it "should set the container revision on the instance" do
        expect(@modified_page.revision).to eq @page.revisions[1]
      end

      it "should not modify the actual page" do
        expect(@page.revision).to_not eq @page.revisions[1]
      end
    end

    describe "setting the revision from the project container" do
      before do
        @modified_page = Ninetails::Container.find_and_load_revision({ id: @page.id }, @project)
        @modified_layout = Ninetails::Container.find_and_load_revision({ id: @layout.id }, @project)
      end

      it "should set the container revision on the instance" do
        expect(@modified_page.revision).to eq @project_container.revision
      end

      it "should not modify the actual page" do
        expect(@page.revision).to_not eq @project_container.revision
      end

      it "should not change the revision if the project does not have a revision for this container" do
        expect(@modified_layout.revision).to eq @layout.revision
      end
    end
  end

  describe "#revision" do
    before do
      @container = create :page, :with_revisions
      @container.update_attributes current_revision: @container.revisions.last
    end

    it "should return the container revision if set" do
      @container.revision = @container.revisions.first
      expect(@container.revision).to eq @container.revisions.first
    end

    it "should return the container current_revision if no custom revision is set" do
      expect(@container.revision).to eq @container.revisions.last
    end
  end

  # TODO - write missing tests

end
