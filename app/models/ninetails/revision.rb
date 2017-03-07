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

    # Check the url is unique across revisions, but only if a container has a matching revision
    # set as its `current_revision`. Otherwise it'd be impossible to change one page's url
    # to a url which was previously used by another page in the past.
    def url_is_unique
      if container.is_a?(Page) && url.present?
        url_exists = Ninetails::Container.
          where.not(id: container.id).
          includes(:current_revision).
          where(ninetails_revisions: { url: url }).
          exists?

        errors.add :url, "is already in use" if url_exists
      end
    end

  end
end
