require 'rails_helper'

class CustomProperty < Ninetails::Property
  property :text, String
  validates :text, presence: true
end

class BasicElement < Ninetails::Element
  property :foo, String
  property :bar, String
end

class EnumerablePropertiesElement < Ninetails::Element
  property :title, String
  property :images, [String]
end

shared_examples "behaving like an element should" do |element, name, type|
  it "should store the name of the element" do
    expect(element.name).to eq name
  end

  it "should store the type of the element" do
    expect(element.type).to eq type
  end

  it "should store the count of the element" do
    expect(element.count).to eq :single
  end

  describe "adding type structure with singles" do
    let(:hash) { Hash.new }

    before do
      element.add_to_hash hash
    end

    it "should add the type's structure to a hash" do
      expect(hash[name]).to eq element.properties_structure
    end
  end

  describe "adding type structure with multiples" do
    let(:hash) { Hash.new }

    before do
      element.count = :multiple
      element.add_to_hash hash
    end

    it "should add the type's structure to a hash as the single item of an array" do
      expect(hash[name]).to eq [element.properties_structure]
    end
  end
end

describe Ninetails::ElementDefinition do

  let(:text_element) { Ninetails::ElementDefinition.new(:foo, Element::Text, :single) }
  let(:enumerable_element) { Ninetails::ElementDefinition.new(:foo, [Element::Text], :single) }

  include_examples "behaving like an element should", Ninetails::ElementDefinition.new(:foo, Element::Text, :single), :foo, Element::Text
  include_examples "behaving like an element should", Ninetails::ElementDefinition.new(:foo, [Element::Text], :single), :foo, Element::Text

  describe "deserialization" do
    describe "single elements", "with normal properties" do
      let(:definition) { Ninetails::ElementDefinition.new(:foo, Element::Text, :single) }
      let(:hash) { {"type"=>"Text", "content"=>{"text"=>"Hello world!"}} }

      it "should add one element to the elements array" do
        expect {
          definition.deserialize hash
        }.to change { definition.elements.size }.from(0).to(1)
      end

      it "should pass the hash into the element to be deserialized" do
        element_instance = Element::Text.new
        allow(Element::Text).to receive(:new) { element_instance }
        expect(element_instance).to receive(:deserialize).with(hash)

        definition.deserialize hash
      end
    end

    describe "multiple elements", "with normal properties" do
      let(:definition) { Ninetails::ElementDefinition.new(:foo, Element::ButtonIcon, :multiple) }
      let(:hash) do
        [
          {"type"=>"ButtonIcon", "link"=>{"url"=>"/foo", "title"=>"Bar", "text"=>"hello"}, "icon"=>{"name"=>"person"}},
          {"type"=>"ButtonIcon", "link"=>{"url"=>"/bar", "title"=>"Baz", "text"=>"box"}, "icon"=>{"name"=>"tree"}}
        ]
      end

      it "should duplicate property types in properties_instances to be the correct number of passed in items" do
        expect {
          definition.deserialize hash
        }.to change { definition.elements.size }.from(0).to(2)
      end

      it "should set the correct property on each instance" do
        first_element_instance = Element::ButtonIcon.new
        second_element_instance = Element::ButtonIcon.new
        allow(Element::ButtonIcon).to receive(:new).and_return(first_element_instance, second_element_instance)
        expect(first_element_instance).to receive(:deserialize).with(hash[0])
        expect(second_element_instance).to receive(:deserialize).with(hash[1])

        definition.deserialize hash
      end

    end
  end

end
