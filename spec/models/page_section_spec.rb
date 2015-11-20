require 'rails_helper'

module SectionTemplate
  class TestSection < Ninetails::SectionTemplate
    located_in :body
    has_element :headline, Element::Text
    has_element :button, Element::Button
    has_many_elements :messages, Element::Text
  end
end

RSpec.describe Ninetails::PageSection, type: :model do

  describe "deserializing a json blob" do
    let(:headline) { "Hello world!" }
    let(:first_message) { "this is the first message" }
    let(:second_message) { "and this is the second" }

    let(:json) do
      {
        "name" => "",
        "type" => "TestSection",
        "tags" => { "position" => "body" },
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

    let(:section) { Ninetails::PageSection.new(json) }

    it "should create a SectionTemplate instance" do
      section.deserialize
      expect(section.template).to be_a SectionTemplate::TestSection
    end

    it "should have an array of elements_instances" do
      section.deserialize
      expect(section.template.elements_instances.size).to eq 3
    end

    it "should include an element for 'text', 'button', and 'link'" do
      section.deserialize
      expect(section.template.elements_instances[0].name).to eq :headline
      expect(section.template.elements_instances[1].name).to eq :button
      expect(section.template.elements_instances[2].name).to eq :messages
    end

    it "should be the correct type for 'text', 'button', and 'link'" do
      section.deserialize
      expect(section.template.elements_instances[0].type).to eq Element::Text
      expect(section.template.elements_instances[1].type).to eq Element::Button
      expect(section.template.elements_instances[2].type).to eq Element::Text
    end

    it "should call deserialize on each element" do
      expect(SectionTemplate::TestSection.find_element("headline")).to receive(:deserialize).with(json["elements"]["headline"])
      expect(SectionTemplate::TestSection.find_element("button")).to receive(:deserialize).with(json["elements"]["button"])
      expect(SectionTemplate::TestSection.find_element("messages")).to receive(:deserialize).with(json["elements"]["messages"])
      section.deserialize
    end

    it "should be possible to reserialize into json" do
      section.deserialize
      serialized = section.template.serialize.with_indifferent_access
      expect(serialized[:elements][:headline][:content][:text]).to eq headline
      expect(serialized[:elements][:messages][0][:content][:text]).to eq first_message
      expect(serialized[:elements][:messages][1][:content][:text]).to eq second_message
    end

  end

  describe "building json" do

    let(:section) { build :document_head_section }
    let(:json) do
      {
        id: section.id,
        name: section.name,
        type: section.type,
        tags: section.tags,
        elements: section.elements
      }.to_json
    end

    it "should build the section into json" do
      expect(section.to_builder.target!).to eq json
    end

  end

end
