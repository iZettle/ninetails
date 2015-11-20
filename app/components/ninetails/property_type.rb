module Ninetails
  class PropertyType
    attr_accessor :name, :type, :serialized_values, :property

    def initialize(name, type)
      @name = name
      @type = type
      @property = type.new
    end

    def serialized_values=(hash)
      @serialized_values = hash
      @property = type.new serialized_values
    end

    def serialize
      if serialized_values.present?
        serialized_values
      elsif type.respond_to? :serialize
        type.serialize
      else
        type.new
      end
    end

  end
end
