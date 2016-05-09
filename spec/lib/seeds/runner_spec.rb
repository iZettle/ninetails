require 'rails_helper'

describe Ninetails::Seeds::Generator, "runner" do

  it "should require layout seeds before page seeds" do
    Ninetails::Seeds::Generator.run
    expect(SeedFiles.files.first).to eq :layout
    expect(SeedFiles.files.last).to eq :page
  end

end
