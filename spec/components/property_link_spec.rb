require 'rails_helper'

describe Ninetails::PropertyLink do

  let(:page_selector_hash) do
    {
      serialize_as: :url,
      from: Ninetails::Page,
      where: { id: :page_id }
    }
  end

  let(:page_link) do
    Ninetails::PropertyLink.new :page_id, page_selector_hash
  end

  it "should store the name and link" do
    expect(page_link.name).to eq :page_id
    expect(page_link.link).to eq page_selector_hash
  end

  describe "select_conditions" do
    it "should substitute the link name with values in the where clause" do
      expect(page_link.select_conditions(page_id: "foo")).to eq({ id: "foo" })
    end
  end

  describe "desconstuct" do
    let(:page) { create :page }

    it "should return the page url" do
      expect(page_link.deconstruct(page_id: page.id)).to eq page.url
    end
  end

end
