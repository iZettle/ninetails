module Section
  class SmartSection < Ninetails::Section

    located_in :body

    has_data :pages, -> { Car.all }

  end
end
