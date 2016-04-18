require 'rails_helper'

module Section
  class TestSection < Ninetails::Section
    located_in :body
    has_element :headline, Element::Text
    has_element :button, Element::Button
    has_many_elements :messages, Element::Text
  end

  class TestPlaceholderSection < Ninetails::Section
    name_as_location :body
  end
end

RSpec.describe Ninetails::ContentSection, type: :model do

  let(:content_section) { Ninetails::ContentSection.new type: "TestSection" }
  let(:content_placeholder_section) { Ninetails::ContentSection.new type: "TestPlaceholderSection" }

  it "should initialize an instance of the section type" do
    expect(content_section.section).to be_a Section::TestSection
  end

  it "should use the #section for getting the content_section's located_in attribute" do
    expect(content_section.located_in).to eq :body
    expect(content_section.location_name).to be nil
  end

  it "should use the #section for getting the content_section's location_name attribute" do
    expect(content_placeholder_section.location_name).to eq :body
    expect(content_placeholder_section.located_in).to be nil
  end

  describe "deserializing a json blob" do
    let(:headline) { "Hello world!" }
    let(:first_message) { "this is the first message" }
    let(:second_message) { "and this is the second" }

    let(:json) do
      {
        "name" => "",
        "type" => "TestSection",
        "elements" => {
          "headline" => {
            "type" => "Text",
            "content" => { "text" => headline }
          },
          "button" => {
            "type" => "Button",
            "link" => {
              "url" => "/foo",
              "title" => "Hello",
              "text" => "world"
            }
          },
          "messages" => [
            {
              "type" => "Text",
              "content" => { "text" => first_message }
            },
            {
              "type" => "Text",
              "content" => { "text" => second_message }
            }
          ]
        }
      }
    end

    let(:json_with_missing_element) do
      {
        "name" => "",
        "type" => "TestSection",
        "elements" => {
          "unknown" => {
            "type" => "ThisDoesntExist",
            "foo" => "Bar"
          },
          "headline" => {
            "type" => "Text",
            "content" => { "text" => headline }
          }
        }
      }
    end

    let(:section) { Ninetails::ContentSection.new(json) }
    let(:section_with_missing_element) { Ninetails::ContentSection.new(json_with_missing_element) }

    describe "when all elements exist" do
      it "should create a Section instance" do
        section.deserialize
        expect(section.section).to be_a Section::TestSection
      end

      it "should have an array of elements_instances" do
        section.deserialize
        expect(section.section.elements_instances.size).to eq 3
      end

      it "should include an element for 'text', 'button', and 'link'" do
        section.deserialize
        expect(section.section.elements_instances[0].name).to eq :headline
        expect(section.section.elements_instances[1].name).to eq :button
        expect(section.section.elements_instances[2].name).to eq :messages
      end

      it "should be the correct type for 'text', 'button', and 'link'" do
        section.deserialize
        expect(section.section.elements_instances[0].type).to eq Element::Text
        expect(section.section.elements_instances[1].type).to eq Element::Button
        expect(section.section.elements_instances[2].type).to eq Element::Text
      end

      it "should call deserialize on each element" do
        expect(Section::TestSection.find_element("headline")).to receive(:deserialize).with(json["elements"]["headline"])
        expect(Section::TestSection.find_element("button")).to receive(:deserialize).with(json["elements"]["button"])
        expect(Section::TestSection.find_element("messages")).to receive(:deserialize).with(json["elements"]["messages"])
        section.deserialize
      end

      it "should be possible to reserialize into json" do
        section.deserialize
        serialized = section.section.serialize.with_indifferent_access
        expect(serialized[:elements][:headline][:content][:text]).to eq headline
        expect(serialized[:elements][:messages][0][:content][:text]).to eq first_message
        expect(serialized[:elements][:messages][1][:content][:text]).to eq second_message
      end
    end

    describe "when some elements don't exist" do
      it "should create a Section instance" do
        section_with_missing_element.deserialize
        expect(section_with_missing_element.section).to be_a Section::TestSection
      end

      it "should not include the broken element in the section elements" do
        section_with_missing_element.deserialize
        expect(section_with_missing_element.section.elements_instances.size).to eq 1
      end

      it "should log an error that the element did not exist" do
        expect(Rails.logger).to receive(:error).with("[Ninetails] TestSection does not have an element named 'unknown'. Skipping.")
        section_with_missing_element.deserialize
      end
    end

  end

end
