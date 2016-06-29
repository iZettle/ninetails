module Ninetails
  class Section

    attr_accessor :elements_instances

    def self.new_from_filename(filename)
      new_from_name File.basename(filename, ".rb")
    end

    def self.new_from_name(name)
      "Section::#{name.camelize}".safe_constantize.new
    end

    def self.located_in(position)
      @position = position
    end

    def self.position
      @position
    end

    def self.name_as_location(location_name)
      @location_name = location_name
    end

    def self.location_name
      @location_name
    end

    def self.define_element(name, type, count)
      @elements ||= []
      @elements << Ninetails::ElementDefinition.new(name, type, count)
    end

    def self.has_element(name, type)
      define_element name, type, :single
    end

    def self.has_many_elements(name, type)
      define_element name, type, :multiple
    end

    def self.elements
      @elements || []
    end

    def self.has_variants(*variants)
      @variants ||= []
      @variants << variants
    end

    def self.variants
      @variants.try(:flatten) || []
    end

    def self.find_element(name)
      elements.find { |element| element.name == name.to_sym }
    end

    def serialize
      {
        name: "",
        type: self.class.name.demodulize,
        located_in: self.class.position,
        location_name: self.class.location_name,
        variants: self.class.variants,
        elements: serialize_elements
      }
    end

    def serialize_elements
      elements = elements_instances || self.class.elements

      elements.each_with_object({}) do |element, hash|
        element.add_to_hash hash
      end
    end

  end
end
