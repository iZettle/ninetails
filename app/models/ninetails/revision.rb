module Ninetails
  class Revision < ActiveRecord::Base

    belongs_to :container
    belongs_to :project
    belongs_to :folder
    has_many :revision_sections
    has_many :sections, -> { order :created_at }, through: :revision_sections

    validate :sections_are_all_valid, :url_is_unique
    validates :locale, presence: true

    after_create :update_project_container, if: -> { project.present? }

    scope :live, -> { joins(:container).where("ninetails_revisions.id = ninetails_containers.current_revision_id") }

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

    def requires_unique_url?
      container.is_a?(Page) && url.present?
    end

    def url_is_unique
      if container.is_a?(Page) && url.present? && Revision.where(url: url).where.not(container: container).exists?
        errors.add :url, "is already in use"
      end
    end

  end
end
