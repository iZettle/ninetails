require 'rails_helper'

RSpec.describe Ninetails::Container, type: :model do

  describe "validations" do
    subject { create :container }

    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url).case_insensitive }
    it { should validate_presence_of(:type) }
  end

end
