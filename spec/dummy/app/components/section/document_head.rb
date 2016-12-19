module Section
  class DocumentHead < Ninetails::Section

    located_in :head

    has_element :title, Element::Text
    has_element :description, Element::Meta

    attribute :foo, Boolean, default: true
  end
end
