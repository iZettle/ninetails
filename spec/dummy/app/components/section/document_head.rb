module Section
  class DocumentHeadSettings
    include Virtus.model
    attribute :foo, Boolean, default: false
  end

  class DocumentHead < Ninetails::Section

    located_in :head

    has_element :title, Element::Text
    has_element :description, Element::Meta

    attribute :settings, DocumentHeadSettings, default: DocumentHeadSettings.new
  end
end
