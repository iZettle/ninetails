module Ninetails
  class PropertyType
    attr_accessor :name, :type, :serialized_values, :property

    def initialize(name, type)
      @name = name

      if type.is_a? Hash
        @type = PropertyLink
        @property = PropertyLink.new name, type
      else
        @type = type
        @property = type.new
      end
    end

    def serialized_values=(values)
      if property.is_a? PropertyLink
        @serialized_values = property.deconstruct(name => values)
      else
        @serialized_values = values
        @property = type.new values
      end
    end

    def serialize
      if serialized_values.present?
        serialized_values
      elsif type.respond_to? :serialize
        type.serialize
      end
    end

  end
end
