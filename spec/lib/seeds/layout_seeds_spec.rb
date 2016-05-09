require 'rails_helper'

describe Ninetails::Seeds do

  class Section::BodySection < Ninetails::Section
    name_as_location :body
  end

  let(:empty_layout_seed) do
    Ninetails::Seeds.generate_layout :main_layout do
      name "Main layout"
    end
  end

  let(:layout_seed_with_sections) do
    Ninetails::Seeds.generate_layout :with_sections do
      name "Another layout"
      add_content_section Section::BodySection
    end
  end

  describe "Creating a layout with no sections" do
    it "should create a layout container" do
      expect {
        empty_layout_seed
      }.to change{ Ninetails::Layout.count }.by(1)
    end

    it "should set the name of the container" do
      expect(empty_layout_seed.name).to eq "Main layout"
    end

    it "should create a revision" do
      expect(empty_layout_seed.current_revision).to be_a Ninetails::Revision
    end
  end

  describe "Creating a layout with sections" do
    it "should create a layout container" do
      expect {
        layout_seed_with_sections
      }.to change{ Ninetails::Layout.count }.by(1)
    end

    it "should create a section" do
      expect {
        layout_seed_with_sections
      }.to change{ Ninetails::ContentSection.count }.by(1)
    end

    it "should create the correct type of section" do
      expect(layout_seed_with_sections.current_revision.sections.first.type).to eq "BodySection"
    end
  end

end
