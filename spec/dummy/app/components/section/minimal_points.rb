module Section
  class MinimalPoints < Ninetails::Section
    located_in :body
    has_many_elements :icons, Element::Figure
  end
end
