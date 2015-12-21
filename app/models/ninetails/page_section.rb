module Ninetails
  class PageSection < ActiveRecord::Base
    self.inheritance_column = nil
    has_many :page_revision_sections
    has_many :page_revisions, through: :page_revision_sections

    def section
      @section ||= "Section::#{type}".safe_constantize.new
    end

    def deserialize
      section.elements_instances = []

      elements.each do |name, element_json|
        element = section.class.find_element name
        element.deserialize element_json
        section.elements_instances << element
      end

      section
    end

  end
end
