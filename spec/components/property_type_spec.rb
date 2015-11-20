require 'rails_helper'

class TextProperty
  include Ninetails::PropertyStore
  property :text, String
end

describe Ninetails::PropertyType do

  let(:string_property) { Ninetails::PropertyType.new :foo, String }
  let(:text_property) { Ninetails::PropertyType.new :foo, TextProperty }

  it "should be initializable with name and type" do
    expect(string_property.name).to eq :foo
    expect(string_property.type).to eq String
  end

  describe "serializing" do
    it "should be a new instance of the type when the type does not respond to #structure" do
      expect(string_property.serialize).to eq ""
    end

    it "should use the structure when the type responds to #structure" do
      allow(String).to receive(:respond_to?) { true }
      allow(String).to receive(:serialize) { "HELLO" }
      expect(string_property.serialize).to eq "HELLO"
    end

    it "should initialize a new instance of the type with the serialized_values attribute as an argument" do
      string_property.serialized_values = "123"
      expect(string_property.serialize).to eq "123"
    end
  end

  describe "property" do
    it "should be set to a new instance of the property type" do
      expect(string_property.property).to be_a String
      expect(text_property.property).to be_a TextProperty
    end
  end

  describe "handling serialized values" do
    it "should be nil when initializing a Ninetails::PropertyType" do
      expect(string_property.serialized_values).to eq nil
    end

    it "should be possible to set" do
      string_property.serialized_values = "foobar"
      expect(string_property.serialized_values).to eq "foobar"
    end

    it "should raise a TypeError if you try to set the wrong type" do
      expect {
        string_property.serialized_values = { foo: "bar" }
      }.to raise_error(TypeError)
    end

    it "should be possible to set with a hash if the property conforms to the Ninetails::PropertyStore" do
      text_property.serialized_values = { text: "hello" }
      expect(text_property.serialized_values).to eq({ text: "hello" })
    end

    it "should use the serialized_values to reinitialize the property" do
      text_property.serialized_values = { text: "hello" }
      expect(text_property.property.text).to eq "hello"
    end
  end

end
