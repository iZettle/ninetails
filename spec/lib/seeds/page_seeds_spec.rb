require 'rails_helper'

describe Ninetails::Seeds::Generator, "pages" do

  let(:empty_page) do
    Ninetails::Seeds::Generator.generate_page do |page|
      page.name "An empty page"
      page.locale "en_US"
      page.url "/empty"
    end
  end

  let(:page_with_sections) do
    Ninetails::Seeds::Generator.generate_page do |page|
      page.name "Another page"
      page.locale "en_US"
      page.url "/another"

      page.content_section Section::MinimalBillboard do |section|
        section.background_image image: { src: "/foo.jpg", alt: "Bar" }
      end
    end
  end

  let(:page_with_sections_with_array) do
    Ninetails::Seeds::Generator.generate_page do |page|
      page.name "A page with a complex section"
      page.locale "en_US"
      page.url "/foobar"

      page.content_section Section::MinimalPoints do |section|
        section.icons [
          { image: { src: "/one.jpg", alt: "One" } },
          { image: { src: "/two.jpg", alt: "Two" } }
        ]
      end
    end
  end

  let(:section) { page_with_sections.current_revision.sections.first }
  let(:section_array) { page_with_sections_with_array.current_revision.sections.first }

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
    it "should create a page container" do
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

  describe "Creating a page with complex sections" do
    it "should create a page container" do
      expect {
        page_with_sections_with_array
      }.to change{ Ninetails::Page.count }.by(1)
    end

    it "should create a section" do
      expect {
        page_with_sections_with_array
      }.to change{ Ninetails::ContentSection.count }.by(1)
    end

    it "should build 2 icon elements in the section" do
      expect(section_array.elements["icons"].length).to eq 2
    end

    it "should create the correct type of section" do
      expect(section_array.type).to eq "MinimalPoints"
    end

    it "should create the correct elements" do
      expect(section_array.elements["icons"][0]["image"]["src"]).to eq "/one.jpg"
      expect(section_array.elements["icons"][1]["image"]["src"]).to eq "/two.jpg"
    end
  end

  describe "Creating a page with a layout" do
    let!(:layout_seed) do
      Ninetails::Seeds::Generator.generate_layout :test_layout do |layout|
        layout.name "Test Layout"
        layout.locale "en_US"
        layout.content_section Section::EmptyBody
      end
    end

    let(:page_with_layout) do
      Ninetails::Seeds::Generator.generate_page do |page|
        page.name "A page with layout"
        page.url "/has-layout"
        page.locale "en_US"
        page.layout :test_layout
      end
    end

    let(:page_with_layout_id) do
      Ninetails::Seeds::Generator.generate_page do |page|
        page.name "Another page"
        page.url "/has-layout-id"
        page.locale "en_US"
        page.layout layout_seed.id
      end
    end

    it "should create a page" do
      expect {
        page_with_layout
      }.to change{ Ninetails::Page.count }.by(1)
    end

    it "should associate with the correct layout using a symbol" do
      expect(page_with_layout.layout).to eq layout_seed
    end

    it "should associate with the correct layout using an id" do
      expect(page_with_layout_id.layout).to eq layout_seed
    end
  end

end
