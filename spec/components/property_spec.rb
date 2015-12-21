require 'rails_helper'

class SecondProperty < Ninetails::Property
  property :finally, String
end

class FirstProperty < Ninetails::Property
  property :first, String
  property :second, SecondProperty
end

class LinkingProperty < Ninetails::Property
  property :page_id, serialize_as: :url, from: Ninetails::Page, where: { id: :page_id }
end

RSpec.describe Ninetails::Property do

  describe "storing simple properties" do
    it "should store properties" do
      expect(FirstProperty.properties.collect(&:name)).to include(:first)
      expect(FirstProperty.properties.collect(&:name)).to include(:second)
    end

    it "should store properties with types" do
      prop = FirstProperty.properties.find{|p| p.name == :first}
      expect(prop.type).to eq String
    end

    it "should represent single-level structure correctly" do
      expect(SecondProperty.serialize).to eq({ finally: nil })
    end

    it "should represent nested properties with nested structure" do
      expect(FirstProperty.serialize).to eq({ first: nil, second: { finally: nil }})
    end
  end

  describe "storing linking properties" do
    it "should create a PropertyLink" do
      expect(LinkingProperty.properties.first.property).to be_a Ninetails::PropertyLink
    end

    it "should store the linking params in the PropertyLink" do
      expect(LinkingProperty.properties.first.property.link[:from]).to eq Ninetails::Page
      expect(LinkingProperty.properties.first.property.link[:where]).to eq({ id: :page_id })
    end
  end

end
