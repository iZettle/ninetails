module Ninetails
  class PropertyType
    attr_accessor :name, :type, :serialized_values, :property, :enumerable

    def initialize(name, type)
      @name = name

      if type.is_a? Array
        @enumerable = true
        @type = type.first
        @property = type.first.new
      else
        @enumerable = false
        @type = type
        @property = type.new
      end
    end

    def serialized_values=(values)
      if values.is_a?(Hash) && !values.with_indifferent_access.has_key?(:reference)
        values[:reference] = SecureRandom.uuid
      end

      @serialized_values = values

      if enumerable && serialized_values.is_a?(Array)
        @property = serialized_values.collect { |value| type.new value }
      else
        @property = type.new serialized_values
      end
    end

    def serialize
      if serialized_values.present?
        serialized_values
      else
        enumerable ? serialize_enumerable_empty : serialize_normal_empty
      end
    end

    private

    # Return nil or type.serialize
    def serialize_normal_empty
      type.serialize if type.respond_to? :serialize
    end

    # Return an empty array or an array with type.serialize
    def serialize_enumerable_empty
      if type.respond_to? :serialize
        [type.serialize]
      else
        []
      end
    end

  end
end
