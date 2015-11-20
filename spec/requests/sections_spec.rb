require 'rails_helper'

describe "Sections API" do

  it "should list the available sections" do
    get "/sections"
    expect(response).to be_success
    expect(json["sections"]).to include "Billboard"
  end

  it "should be possible to get a section's structure" do
    get "/sections/Billboard"
    expect(response).to be_success
    expect(response.body).to eq Section::Billboard.new.serialize.to_json
  end

end
