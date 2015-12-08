module Ninetails
  class Element
    include Ninetails::PropertyStore

    def reference
      @reference ||= SecureRandom.uuid
    end

    def name
      @name ||= self.class.name.demodulize
    end

    def deserialize(input)
      properties_instances.collect do |property|
        property.serialized_values = input[property.name.to_s]
      end
    end

    def properties_structure
      generate_structure.convert_keys(:to_api).with_indifferent_access
    end

    # Validate each property_type's property.
    #
    # If the property_type doesn't respond to valid?, then it means it must be a
    # native type, or at least not something which inherits Ninetails::Property, so we will class it
    # as valid blindly.
    def valid?
      validations = properties_instances.collect do |property_type|
        if property_type.property.respond_to?(:valid?)
          property_type.property.valid?
        else
          true
        end
      end

      validations.all?
    end

    private

    def properties_instances
      @properties_instances ||= self.class.properties.collect(&:clone)
    end

    def generate_structure
      properties_instances.each_with_object({}) do |property_type, hash|
        hash[:type] = name
        hash[:reference] = reference
        hash[property_type.name] = property_type.serialize

        if property_type.property.try(:errors).try(:present?)
          hash[property_type.name].merge! errors: property_type.property.errors.messages
        end
      end
    end

  end
end
