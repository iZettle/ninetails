require "rails_helper"

describe Ninetails::Link do

  it { should belong_to(:container) }
  it { should belong_to(:linked_container) }

end
