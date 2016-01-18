require 'rails_helper'

class NoPropertiesDefined
  include Ninetails::PropertyStore
end

class SomeProperties
  include Ninetails::PropertyStore
  property :text, Property::Text
end

class PropertiesWithValidations
  include Ninetails::PropertyStore
  property :text, String
  validates :text, presence: true
end

describe Ninetails::PropertyStore do

  it "should expose a list of properties on the class" do
    expect(NoPropertiesDefined).to respond_to :properties
  end

  it "should have an empty array of properties to begin with" do
    expect(NoPropertiesDefined.properties).to eq []
  end

  it "should store properties using Ninetails::PropertyType" do
    expect(SomeProperties.properties.first).to be_a Ninetails::PropertyType
  end

  it "should store the name of a defined property" do
    expect(SomeProperties.properties.first.name).to eq :text
  end

  it "should store the type of a defined property" do
    expect(SomeProperties.properties.first.type).to eq Property::Text
  end

  it "should store the property as a virtus attribute" do
    virtus_attr = SomeProperties.attribute_set.find { |a| a.name == :text}
    expect(virtus_attr.name).to eq :text
    expect(virtus_attr.primitive).to eq Property::Text
  end

  describe "validations" do

    let(:prop) { PropertiesWithValidations.new text: nil }

    before do
      prop.valid? # run validations
    end

    it "should be possible to validate the propery group" do
      expect(prop.valid?).to be false
    end

    it "should list errors using ActiveModel::Errors" do
      expect(prop.errors.size).to eq 1
    end

  end

end
