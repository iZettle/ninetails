require 'rails_helper'

RSpec.describe Ninetails::Revision, type: :model do

  it { should belong_to(:container) }
  it { should belong_to(:project) }
  it { should have_many(:revision_sections).dependent(:destroy) }
  it { should have_many(:sections).order(:created_at) }

  # TODO: Write missing tests!

end
