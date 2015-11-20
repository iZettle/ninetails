module Ninetails
  class PageRevision < ActiveRecord::Base
    belongs_to :page
    has_many :page_revision_sections
    has_many :sections, through: :page_revision_sections

    validate :sections_are_all_valid

    private

    # Validate all sections and rebuild the sections array with the instances which now
    # contain error messages
    def sections_are_all_valid
      sections.each do |section|
        deserialized_section = section.deserialize

        deserialized_section.elements_instances.each do |element_definition|
          unless element_definition.all_elements_valid?
            errors.add :base, "Element #{element_definition.name} is not valid"
          end
        end

        section.elements = deserialized_section.serialize[:elements]
      end
    end

  end
end
