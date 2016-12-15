module Ninetails
  class ContentSection < ActiveRecord::Base
    self.inheritance_column = nil
    has_many :revision_sections
    has_many :revisions, through: :revision_sections

    validate :validate_elements

    def section
      @section ||= "Section::#{type}".safe_constantize.new
    end

    def located_in
      section.class.position
    end

    def location_name
      section.class.location_name
    end

    def deserialize
      section.elements_instances = []

      elements.each do |name, element_json|
        element = section.class.find_element name

        if element.present?
          element.deserialize element_json
          section.elements_instances << element
        else
          Rails.logger.error "[Ninetails] #{section.class.name.demodulize} does not have an element named '#{name}'. Skipping."
        end
      end

      section
    end

    # Because the submitted data is always strings, send everything through virtus attrs so it
    # gets cast to the correct class.
    #
    # Then, use the newly cast attributes to store in the settings json blob
    def store_settings(settings_hash)
      settings_hash.each do |key, value|
        section.public_send "#{key}=", value
      end

      self.settings = section.attributes
    end

    private

    def validate_elements
      deserialized_section = deserialize

      deserialized_section.elements_instances.each do |element_definition|
        unless element_definition.all_elements_valid?
          errors.add :base, "Element #{element_definition.name} is not valid"
        end
      end

      self.elements = deserialized_section.serialize[:elements]
    end

  end
end
