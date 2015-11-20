module Property
  class Text < Ninetails::Property

    property :text, String
    validates :text, presence: true

  end
end
