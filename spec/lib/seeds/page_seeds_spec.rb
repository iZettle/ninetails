require 'rails_helper'

describe Ninetails::Seeds::Generator, "pages" do

  let(:empty_page) do
    Ninetails::Seeds::Generator.generate_page do
      name "An empty page"
      url "/empty"
    end
  end

  let(:page_with_sections) do
    Ninetails::Seeds::Generator.generate_page do
      name "Another page"
      url "/another"

      content_section Section::MinimalBillboard do
        background_image image: { src: "/foo.jpg", alt: "Bar" }
      end
    end
  end

  let(:section) { page_with_sections.current_revision.sections.first }

  describe "Creating a page with no sections" do
    it "should create a page container" do
      expect {
        empty_page
      }.to change{ Ninetails::Page.count }.by(1)
    end

    it "should set the name of the container" do
      expect(empty_page.name).to eq "An empty page"
    end

    it "should create a revision" do
      expect(empty_page.current_revision).to be_a Ninetails::Revision
    end
  end

  describe "Creating a page with sections" do
    it "should create a layout container" do
      expect {
        page_with_sections
      }.to change{ Ninetails::Page.count }.by(1)
    end

    it "should create a section" do
      expect {
        page_with_sections
      }.to change{ Ninetails::ContentSection.count }.by(1)
    end

    it "should create the correct type of section" do
      expect(section.type).to eq "MinimalBillboard"
    end

    it "should set the properties in the section" do
      expect(section.elements["background_image"]["image"]["src"]).to eq "/foo.jpg"
      expect(section.elements["background_image"]["image"]["alt"]).to eq "Bar"
    end
  end

end
