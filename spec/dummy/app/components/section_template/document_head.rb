module SectionTemplate
  class DocumentHead < Ninetails::SectionTemplate

    located_in :head

    has_element :title, Element::Text
    has_element :description, Element::Meta

  end
end
