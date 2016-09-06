module Section
  class LongNameSection < Ninetails::Section

    located_in :body

    has_element :long_name_element, Element::LongNameElement

  end
end
