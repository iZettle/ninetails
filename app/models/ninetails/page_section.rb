module Ninetails
  class PageSection < ActiveRecord::Base
    self.inheritance_column = nil
    has_many :page_revision_sections
    has_many :page_revisions, through: :page_revision_sections

    validate :validate_elements

    def section
      @section ||= "Section::#{type}".safe_constantize.new
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
