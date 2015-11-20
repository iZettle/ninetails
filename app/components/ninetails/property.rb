module Ninetails
  class Property
    include Ninetails::PropertyStore

    def self.serialize
      properties.each_with_object({}) do |property, hash|
        hash[property.name] = property.serialize
      end
    end
  end
end
