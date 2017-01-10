require "rails_helper"

describe Ninetails::Folder do

  it { should have_many :revisions }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

end
