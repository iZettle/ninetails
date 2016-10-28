module Ninetails
  class Revision < ActiveRecord::Base

    belongs_to :container
    belongs_to :project
    has_many :revision_sections
    has_many :sections, -> { order :created_at }, through: :revision_sections

    validate :sections_are_all_valid
    validates :url, presence: true, uniqueness: { case_sensitive: false }, if: -> { container.is_a? Ninetails::Page }

    after_create :update_project_container, if: -> { project.present? }

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

    def update_project_container
      project_container = ProjectContainer.find_or_initialize_by project_id: project.id, container_id: container.id
      project_container.revision = self
      project_container.save
    end

  end
end
