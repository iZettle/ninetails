module Ninetails
  class PageSection < ActiveRecord::Base
    self.inheritance_column = nil
    has_many :page_revision_sections
    has_many :page_revisions, through: :page_revision_sections

    def to_builder
      Jbuilder.new do |json|
        json.call(self, :id, :name, :type, :tags, :elements)
      end
    end

    def template
      @template ||= "SectionTemplate::#{type}".safe_constantize.new
    end

    def deserialize
      template.elements_instances = []

      elements.each do |name, element_json|
        element = template.class.find_element name
        element.deserialize element_json
        template.elements_instances << element
      end

      template
    end

  end
end
