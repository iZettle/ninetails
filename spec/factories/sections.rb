FactoryGirl.define do

  factory :document_head_section, class: Ninetails::Section do
    type "DocumentHead"
    tags SectionTemplate::DocumentHead.new.tags
    elements SectionTemplate::DocumentHead.new.serialize_elements
  end

  factory :billboard_section, class: Ninetails::Section do
    type "Billboard"
    tags SectionTemplate::Billboard.new.tags
    elements SectionTemplate::Billboard.new.serialize_elements
  end

end
