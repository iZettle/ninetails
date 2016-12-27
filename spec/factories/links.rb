FactoryGirl.define do

  factory :link, class: Ninetails::Link do
    association :container
    association :linked_container, factory: :container
    relationship "hreflang"
  end

end
