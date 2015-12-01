module Section
  class MinimalBillboard < Ninetails::Section

    located_in :body

    has_element :background_image, Element::Figure

  end
end
