require 'rails_helper'

describe "Section Templates API" do

  it "should list the available templates" do
    get "/section_templates"
    expect(response).to be_success
    expect(json["templates"]).to include "Billboard"
  end

  it "should be possible to get a section's structure" do
    get "/section_templates/Billboard"
    expect(response).to be_success
    expect(response.body).to eq SectionTemplate::Billboard.new.serialize.to_json
  end

end
