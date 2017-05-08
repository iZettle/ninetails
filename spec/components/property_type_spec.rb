require 'rails_helper'

class TextProperty
  include Ninetails::PropertyStore
  property :text, String
end

class EnumerableProperty
  include Ninetails::PropertyStore
  property :texts, [String]
end

describe Ninetails::PropertyType do

  let(:string_property) { Ninetails::PropertyType.new :foo, String }
  let(:text_property) { Ninetails::PropertyType.new :foo, TextProperty }
  let(:enumerable_property) { Ninetails::PropertyType.new :foo, [TextProperty] }

  describe "normal properties" do
    it "should store the name and type" do
      expect(string_property.name).to eq :foo
      expect(string_property.type).to eq String
    end

    it "should not be enumerable" do
      expect(string_property.enumerable).to be false
    end
  end

  describe "enumerable properties" do
    it "should store the name and type" do
      expect(enumerable_property.name).to eq :foo
      expect(enumerable_property.type).to eq TextProperty
    end

    it "should be enumerable" do
      expect(enumerable_property.enumerable).to be true
    end
  end

  describe "serializing normal properties" do
    it "should be nil when the type does not respond to #structure" do
      expect(string_property.serialize).to eq nil
    end

    it "should use the structure when the type responds to #serialize" do
      allow(String).to receive(:respond_to?) { true }
      allow(String).to receive(:serialize) { "HELLO" }
      expect(string_property.serialize).to eq "HELLO"
    end

    it "should initialize a new instance of the type with the serialized_values attribute as an argument" do
      string_property.serialized_values = "123"
      expect(string_property.serialize).to eq "123"
    end

    describe "when the serialized_values is a hash" do
      it "should not modify a reference if it exists" do
        text_property.serialized_values = { text: "bar", reference: "123" }
        expect(text_property.serialize[:reference]).to eq("123")
      end

      it "should not matter if the key is passed as a string or a symbol" do
        text_property.serialized_values = { "text" => "bar", "reference" => "123" }
        expect(text_property.serialize["text"]).to eq("bar")
        expect(text_property.serialize[:text]).to eq(nil)

        expect(text_property.serialize["reference"]).to eq("123")
        expect(text_property.serialize[:reference]).to eq(nil)
      end

      it "should generate a reference if the hash doesn't have one" do
        allow(SecureRandom).to receive(:uuid) { "ABC" }
        text_property.serialized_values = { text: "bar" }
        expect(text_property.serialize).to eq({ text: "bar", reference: "ABC" })
      end
    end
  end

  describe "serialing enumerable properties" do
    describe "when serialized_values is blank" do
      it "should be an empty array when the type does not respond to #serialize" do
        expect(enumerable_property.serialize).to eq []
      end

      it "should use the structure when the type responds to #serialize" do
        allow(TextProperty).to receive(:respond_to?) { true }
        allow(TextProperty).to receive(:serialize) { "HELLO" }
        expect(enumerable_property.serialize).to eq ["HELLO"]
      end
    end

    describe "when serialized_values is not blank" do
      it "should initialize a new instance of the type with the serialized_values attribute as an argument" do
        enumerable_property.serialized_values = [{ text: "123" }, { text: "456" }]
        expect(enumerable_property.serialize).to eq [{ :text => "123"}, { :text => "456"}]
      end
    end
  end

  describe "property" do
    it "should be set to a new instance of the property type" do
      expect(string_property.property).to be_a String
      expect(text_property.property).to be_a TextProperty
      expect(enumerable_property.property).to be_a TextProperty
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

    it "should raise a ArgumentError if you try to set the wrong type" do
      expect {
        string_property.serialized_values = { foo: "bar" }
      }.to raise_error
    end

    it "should be possible to set with a hash if the property conforms to the Ninetails::PropertyStore" do
      text_property.serialized_values = { text: "hello" }
      expect(text_property.serialized_values[:text]).to eq "hello"
    end

    it "should use the serialized_values to reinitialize the property" do
      text_property.serialized_values = { text: "hello" }
      expect(text_property.property.text).to eq "hello"
    end

    it "should be possible to reserialize enumerable properties" do
      enumerable_property.serialized_values = [{ text: "hello" }, { text: "world" }]
      expect(enumerable_property.property[0].text).to eq "hello"
      expect(enumerable_property.property[1].text).to eq "world"
    end
  end

end
