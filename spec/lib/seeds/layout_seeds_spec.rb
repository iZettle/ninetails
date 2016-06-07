require 'rails_helper'

describe Ninetails::Seeds::Generator, "layouts" do

  let(:empty_layout_seed) do
    Ninetails::Seeds::Generator.generate_layout :main_layout do |layout|
      layout.name "Main layout"
      layout.locale "en_US"
    end
  end

  let(:layout_seed_with_sections) do
    Ninetails::Seeds::Generator.generate_layout :with_sections do |layout|
      layout.name "Another layout"
      layout.locale "en_US"
      layout.content_section Section::EmptyBody
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
      expect(layout_seed_with_sections.current_revision.sections.first.type).to eq "EmptyBody"
    end
  end

end
