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
    it "should store properties" do
      expect(FirstProperty.properties.collect(&:name)).to include(:first)
      expect(FirstProperty.properties.collect(&:name)).to include(:second)
    end

    it "should store properties with types" do
      prop = FirstProperty.properties.find{|p| p.name == :first}
      expect(prop.type).to eq String
    end

    it "should represent single-level structure correctly" do
      expect(SecondProperty.serialize).to eq({ finally: "" })
    end

    it "should represent nested properties with nested structure" do
      expect(FirstProperty.serialize).to eq({ first: "", second: { finally: "" }})
    end
  end

end
