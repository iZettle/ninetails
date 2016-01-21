module Ninetails
  class PageRevision < ActiveRecord::Base

    belongs_to :page
    belongs_to :project
    has_many :page_revision_sections
    has_many :sections, through: :page_revision_sections

    validate :sections_are_all_valid

    private

    # Validate all sections and rebuild the sections array with the instances which now
    # contain error messages
    def sections_are_all_valid
      sections.each do |section|
        unless section.valid?
          errors.add :base, section.errors.messages[:base]
        end
      end
    end

  end
end
