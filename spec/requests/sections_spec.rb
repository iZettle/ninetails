require 'rails_helper'

describe "Sections API" do

  it "should list the available sections" do
    get "/sections"
    expect(response).to be_success
    billboardJson = json["sections"].find { |s| s["type"] == "Billboard" }.to_json
    expect(billboardJson).to eq Section::Billboard.new.serialize.to_json
  end

  it "should be possible to get a section's structure" do
    get "/sections/Billboard"
    expect(response).to be_success
    expect(response.body).to eq Section::Billboard.new.serialize.to_json
  end

end
