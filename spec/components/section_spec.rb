require 'rails_helper'

class ExampleSection < Ninetails::Section
  located_in :body
  has_element :foo, Element::Text
  has_element :bar, Element::Button
  attribute :hello, String, default: "World"
end

class ExamplePlaceholderSection < Ninetails::Section
  name_as_location :body
  has_element :foo, Element::Text
end

class ExampleSectionWithNoElements < Ninetails::Section
  name_as_location :example
end

class ExampleSectionWithVariants < Ninetails::Section
  located_in :body
  has_variants :light, :dark, :neon
end

class ExampleSectionWithMultipleVariants < Ninetails::Section
  located_in :body
  has_variants :light, :dark
  has_variants :good, :evil
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

  describe "locations" do
    it "should be possible to set the location a section is part of" do
      expect(ExampleSection.position).to eq :body
    end

    it "be possible to set a section as a location for other sections to be set in" do
      expect(ExamplePlaceholderSection.location_name).to eq :body
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
    let(:placeholder_structure) { ExamplePlaceholderSection.new.serialize }
    let(:variants_structure) { ExampleSectionWithVariants.new.serialize }

    it "should have a type key which is the section class name" do
      expect(structure[:type]).to eq "ExampleSection"
    end

    it "should include the default settings" do
      expect(structure[:settings][:hello]).to eq "World"
    end

    it "should include the position in locatedIn" do
      expect(structure[:located_in]).to eq ExampleSection.position
    end

    it "should include the location name if it is defined" do
      expect(placeholder_structure[:location_name]).to eq ExamplePlaceholderSection.location_name
    end

    it "should have an elements key which contains the section's elements" do
      expect(structure[:elements]).to eq ExampleSection.new.serialize_elements
    end

    it "should serialize a section which has no elements" do
      expect {
        ExampleSectionWithNoElements.new.serialize
      }.not_to raise_error
    end

    it "should still have an elements key if the section has no elements" do
      expect(ExampleSectionWithNoElements.new.serialize[:elements]).to eq Hash.new
    end

    it "should include variants when they are defined" do
      expect(variants_structure[:variants]).to eq [:light, :dark, :neon]
    end

    it "should include an empty set of variants when none are defined" do
      expect(structure[:variants]).to eq []
    end
  end

  describe "variants" do
    it "should store a list of variants" do
      expect(ExampleSectionWithVariants.variants).to eq [:light, :dark, :neon]
    end

    it "should allow multiple has_variants calls to store a list of variants" do
      expect(ExampleSectionWithMultipleVariants.variants).to eq [:light, :dark, :good, :evil]
    end

    it "should have no variants by default" do
      expect(ExampleSection.variants).to eq []
    end
  end

  describe "data" do
    it "should include data in the structure" do
      expect(Section::CarsSection.new.serialize[:data][:cars]).to eq Car.all
    end

    it "should default to an empty hash" do
      expect(ExampleSection.new.serialize[:data]).to eq Hash.new
    end
  end

end
