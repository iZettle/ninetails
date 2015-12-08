require 'rails_helper'

class CustomProperty < Ninetails::Property
  property :text, String
  validates :text, presence: true
end

class ExampleElement < Ninetails::Element
  property :foo, String
  property :bar, String
end

class ExampleElement2 < Ninetails::Element
  property :foo, CustomProperty
  property :bar, CustomProperty
end

class ElementForValidating < Ninetails::Element
  property :something, CustomProperty
end

RSpec.describe Ninetails::Element do

  describe "properties" do
    it "should store properties as an array of Property instances" do
      expect(ExampleElement.properties).to be_a(Array)
      expect(ExampleElement.properties.first).to be_a(Ninetails::PropertyType)
    end

    it "should store the property names" do
      expect(ExampleElement.properties[0].name).to eq(:foo)
      expect(ExampleElement.properties[1].name).to eq(:bar)
    end
  end

  describe "generating a reference" do
    it "should use a SecureRandom uuid" do
      allow(SecureRandom).to receive(:uuid) { "ABC" }
      expect(ExampleElement.new.reference).to eq "ABC"
    end

    it "should be unique for each instance of the Element" do
      expect(ExampleElement.new.reference).not_to eq ExampleElement.new.reference
    end
  end

  describe "serialization" do
    let(:element) { ExampleElement.new }
    let(:structure) { element.properties_structure }

    it "should be a hash" do
      expect(structure).to be_a(Hash)
    end

    it "should contain a unique element id" do
      expect(structure[:reference]).to eq element.reference
    end

    it "should have a :type key which is the class name" do
      expect(structure[:type]).to eq "ExampleElement"
    end

    it "should have a key for each property with nil as the value" do
      expect(structure[:foo]).to eq nil
      expect(structure[:bar]).to eq nil
    end
  end

  describe "deserialization" do
    let(:element) { ExampleElement2.new }
    let(:hash) do
      {"type"=>"ExampleElement2", "reference"=>"6ebf107b-c8e5-48f3-bd65-c6d3f8beba90", "foo"=>{"text"=>"hello"}, "bar"=>{"text"=>"world"}}
    end

    it "should set the serialized_values on each property" do
      expect(element.send(:properties_instances).first).to receive(:serialized_values=).with("text"=>"hello")
      expect(element.send(:properties_instances).last).to receive(:serialized_values=).with("text"=>"world")
      element.deserialize hash
    end
  end

  describe "validating properties" do
    let(:invalid_element) { ElementForValidating.new }
    let(:valid_element) { ExampleElement.new }

    it "should check if each property is valid" do
      expect(invalid_element.valid?).to eq false
      expect(valid_element.valid?).to eq true
    end
  end

end
