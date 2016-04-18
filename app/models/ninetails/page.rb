module Ninetails
  class Page < Container
    belongs_to :layout

    validates :url, presence: true, uniqueness: { case_sensitive: false }
  end
end
