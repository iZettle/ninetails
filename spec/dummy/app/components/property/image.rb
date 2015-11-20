module Property
  class Image < Ninetails::Property

    property :src, String
    property :alt, String

    validates :src, :alt, presence: true

  end
end
