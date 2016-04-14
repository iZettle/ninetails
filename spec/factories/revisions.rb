FactoryGirl.define do

  # Default page revision factory has no sections... They're complicated to mock and make valid
  # and all the tests which currently use them, build them manually anyway...
  factory :revision, class: Ninetails::Revision do
  end

end
