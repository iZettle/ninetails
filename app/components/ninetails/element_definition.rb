module Ninetails
  class ElementDefinition
    attr_accessor :name, :type, :count, :elements, :options

    delegate :properties, to: :type

    def initialize(name, type, count, options={})
      @name = name
      @type = type
      @count = count
      @options = options
      @elements = []
    end

    def add_to_hash(hash)
      if count == :single
        hash[name] = single_element_structure
      else
        hash[name] = multiple_element_structure
      end
    end

    def deserialize(input)
      self.elements = []

      if input.is_a? Array
        input.each do |hash|
          add_element hash
        end
      else
        add_element input
      end
    end

    def properties_structure
      @properties_structure ||= type.new(options).properties_structure
    end

    def all_elements_valid?
      elements.all?(&:valid?)
    end

    private

    def single_element_structure
      if elements.present?
        elements.first.properties_structure
      else
        properties_structure
      end
    end

    def multiple_element_structure
      if elements.present?
        elements.collect(&:properties_structure)
      else
        [properties_structure]
      end
    end

    def add_element(input)
      element = type.new
      element.note = options[:note] if options[:note].present?
      element.deserialize input
      elements << element
    end

  end
end
