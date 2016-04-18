FactoryGirl.define do

  factory :document_head_section, class: Ninetails::ContentSection do
    type "DocumentHead"
    elements Section::DocumentHead.new.serialize_elements
  end

  factory :billboard_section, class: Ninetails::ContentSection do
    type "Billboard"
    elements Section::Billboard.new.serialize_elements
  end

end
