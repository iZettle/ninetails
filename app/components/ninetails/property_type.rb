module Ninetails
  class PropertyType
    attr_accessor :name, :type, :serialized_values, :property

    def initialize(name, type)
      @name = name
      @type = type
      @property = type.new
    end

    def serialized_values=(values)
      if values.is_a?(Hash) && !values.has_key?(:reference)
        values[:reference] = SecureRandom.uuid
      end

      @serialized_values = values
      @property = type.new serialized_values
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
