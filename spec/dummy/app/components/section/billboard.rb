module Section
  class Billboard < Ninetails::Section

    located_in :body

    has_element :title, Element::Text, note: "This should be kept short"
    has_element :background_image, Element::Figure
    has_element :signup_button, Element::Button

    has_many_elements :supported_card_icons, Element::Figure
    has_many_elements :supported_device_icons, Element::Figure

  end
end
