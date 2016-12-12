module Section
  class CarsSection < Ninetails::Section

    located_in :body

    has_element :title, Element::OptionalText

    has_data :cars, -> { Car.all }

  end
end
