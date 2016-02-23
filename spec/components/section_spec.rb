require 'rails_helper'

class ExampleSection < Ninetails::Section
  located_in :body
  has_element :foo, Element::Text
  has_element :bar, Element::Button
end

RSpec.describe Ninetails::Section do

  describe "creating a section from a file name" do
    it "should handle plural names" do
      expect(Ninetails::Section.new_from_filename("points")).to be_a Section::Points
    end

    it "should handle singular names" do
      expect(Ninetails::Section.new_from_filename("billboard")).to be_a Section::Billboard
    end

    it "should handle names with suffices" do
      expect(Ninetails::Section.new_from_filename("billboard.rb")).to be_a Section::Billboard
    end

    it "should handle absolute paths" do
      expect(Ninetails::Section.new_from_filename("/foo/bar/billboard.rb")).to be_a Section::Billboard
    end
  end

  describe "position" do
    it "should be possible to set" do
      expect(ExampleSection.position).to eq :body
    end

    it "should raise an exception if the position is not one of head or body" do
      expect{ ExampleSection.located_in(:a_cave) }.to raise_error(Ninetails::SectionConfigurationError)
    end
  end

  describe "elements" do
    it "should store elements as a Array" do
      expect(ExampleSection.elements).to be_a Array
    end

    it "should store the element names" do
      expect(ExampleSection.elements[0].name).to eq :foo
      expect(ExampleSection.elements[1].name).to eq :bar
    end

    it "should store the element types" do
      expect(ExampleSection.elements[0].type).to eq Element::Text
      expect(ExampleSection.elements[1].type).to eq Element::Button
    end
  end

  describe "elements structure" do
    before do
      # Mock SecureRandom so we can reliably compare property strucures without worrying about
      # references which don't match
      allow(SecureRandom).to receive(:uuid) { "123" }
    end

    let(:structure) { ExampleSection.new.serialize_elements }

    it "should be a hash" do
      expect(structure).to be_a(Hash)
    end

    it "should have the property structure for each element" do
      expect(structure[:foo]).to eq Ninetails::ElementDefinition.new(:bogus, Element::Text, :single).properties_structure
      expect(structure[:bar]).to eq Ninetails::ElementDefinition.new(:bogus, Element::Button, :single).properties_structure
    end
  end

  describe "structure" do
    let(:structure) { ExampleSection.new.serialize }

    it "should have a type key which is the section class name" do
      expect(structure[:type]).to eq "ExampleSection"
    end

    it "should include the position in tags" do
      expect(structure[:tags][:position]).to eq ExampleSection.position
    end

    it "should have an elements key which contains the section's elements" do
      expect(structure[:elements]).to eq ExampleSection.new.serialize_elements
    end
  end

end
