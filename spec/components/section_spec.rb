require 'rails_helper'

class ExampleSection < Ninetails::Section
  located_in :body
  has_element :foo, Element::Text
  has_element :bar, Element::Button
end

class SectionWithNote < Ninetails::Section
  located_in :body
  has_element :foo, Element::Text, note: "This is a note"
end

RSpec.describe Ninetails::Section do

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

    it "should store notes on the element" do
      expect(SectionWithNote.elements[0].options[:note]).to eq "This is a note"
    end
  end

  describe "elements structure" do
    before do
      # Mock SecureRandom so we can reliably compare property strucures without worrying about
      # references which don't match
      allow(SecureRandom).to receive(:uuid) { "123" }
    end

    let(:structure) { ExampleSection.new.serialize_elements }
    let(:note_section_structure) { SectionWithNote.new.serialize_elements }

    let(:foo_structure) do
      {"type"=>"Text", "reference"=>"123", "content"=>{"reference"=>"123", "text"=>nil}}
    end

    let(:bar_structure) do
      {"type"=>"Button", "reference"=>"123", "link"=>{"reference"=>"123", "url"=>nil, "title"=>nil, "text"=>nil}}
    end

    let(:note_structure) do
      {"type"=>"Text", "reference"=>"123", "note"=>"This is a note", "content"=>{"reference"=>"123", "text"=>nil}}
    end

    it "should be a hash" do
      expect(structure).to be_a(Hash)
    end

    it "should have the property structure for each element" do
      expect(structure[:foo]).to eq foo_structure
      expect(structure[:bar]).to eq bar_structure
    end

    it "should include the note if the element has one" do
      expect(note_section_structure[:foo]).to eq note_structure
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
