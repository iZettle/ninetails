require 'rails_helper'

RSpec.describe Ninetails::PageRevision, type: :model do

  it { should belong_to(:page) }
  it { should belong_to(:project) }
  it { should have_many(:page_revision_sections) }
  it { should have_many(:sections) }

  # TODO: Write missing tests!

end
