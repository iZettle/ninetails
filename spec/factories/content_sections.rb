FactoryGirl.define do

  factory :document_head_section, class: Ninetails::ContentSection do
    type "DocumentHead"
    tags Section::DocumentHead.new.tags
    elements Section::DocumentHead.new.serialize_elements
  end

  factory :billboard_section, class: Ninetails::ContentSection do
    type "Billboard"
    tags Section::Billboard.new.tags
    elements Section::Billboard.new.serialize_elements
  end

end
