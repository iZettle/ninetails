module Ninetails
  class Config

    cattr_accessor :key_style
    self.key_style = :camelcase

    cattr_accessor :components_directory
    self.components_directory = "app/components"

  end
end
