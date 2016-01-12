require 'rails_helper'

class SecondProperty < Ninetails::Property
  property :finally, String
end

class FirstProperty < Ninetails::Property
  property :first, String
  property :second, SecondProperty
end

RSpec.describe Ninetails::Property do

  describe "storing properties" do
    before do
      allow(SecureRandom).to receive(:uuid).and_return("ABC")
    end

    it "should store properties" do
      expect(FirstProperty.properties.collect(&:name)).to include(:first)
      expect(FirstProperty.properties.collect(&:name)).to include(:second)
    end

    it "should store properties with types" do
      prop = FirstProperty.properties.find{|p| p.name == :first}
      expect(prop.type).to eq String
    end

    it "should represent single-level structure correctly" do
      expect(SecondProperty.serialize).to eq({ finally: nil, reference: "ABC" })
    end

    it "should represent nested properties with nested structure" do
      expect(FirstProperty.serialize).to eq({ reference: "ABC", first: nil, second: { reference: "ABC", finally: nil }})
    end
  end

  describe "generating a reference" do
    it "should use a SecureRandom uuid" do
      allow(SecureRandom).to receive(:uuid) { "ABC" }
      expect(FirstProperty.serialize[:reference]).to eq "ABC"
    end

    it "should be unique for each instance of the Element" do
      expect(FirstProperty.serialize[:reference]).not_to eq FirstProperty.serialize[:reference]
    end
  end

end
