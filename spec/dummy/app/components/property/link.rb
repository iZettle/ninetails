module Property
  class Link < Ninetails::Property

    property :url, String
    property :title, String
    property :text, String

    validates :url, :title, :text, presence: true

  end
end
