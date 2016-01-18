module Ninetails
  class Section
    ALLOWED_POSITIONS = [:head, :body]

    attr_accessor :elements_instances

    def self.located_in(position)
      unless ALLOWED_POSITIONS.include?(position)
        fail SectionConfigurationError, "position must be in #{ALLOWED_POSITIONS}"
      end

      @position = position
    end

    def self.position
      @position
    end

    def self.define_element(name, type, count, options={})
      @elements ||= []
      @elements << Ninetails::ElementDefinition.new(name, type, count, options)
    end

    def self.has_element(name, type, options={})
      define_element name, type, :single, options
    end

    def self.has_many_elements(name, type, options={})
      define_element name, type, :multiple, options
    end

    def self.elements
      @elements
    end

    def self.find_element(name)
      elements.find { |element| element.name == name.to_sym }
    end

    def serialize
      {
        name: "",
        type: self.class.name.demodulize,
        tags: tags,
        elements: serialize_elements
      }
    end

    def tags
      {
        position: self.class.position
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
