require 'rails_helper'

RSpec.describe Ninetails::Page, type: :model do

  describe "validations" do
    subject { create :page }

    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url).case_insensitive }
  end

end
