module Ninetails
  class PageRevision < ActiveRecord::Base

    belongs_to :page
    belongs_to :project
    has_many :page_revision_sections
    has_many :sections, through: :page_revision_sections

    validate :sections_are_all_valid

    after_create :update_project_page, if: -> { project.present? }

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

    def update_project_page
      project_page = ProjectPage.find_or_initialize_by project_id: project.id, page_id: page.id
      project_page.page_revision = self
      project_page.save
    end

  end
end
