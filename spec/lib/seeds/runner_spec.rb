require 'rails_helper'

describe Ninetails::Seeds, "runner" do

  it "should require layout seeds before page seeds" do
    Ninetails::Seeds.run
    expect(SeedFiles.files.first).to eq :layout
    expect(SeedFiles.files.last).to eq :page
  end

end
