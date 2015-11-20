module Property
  class Icon < Ninetails::Property

    property :name, String
    validates :name, presence: true

  end
end
