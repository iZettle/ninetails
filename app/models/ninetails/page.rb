module Ninetails
  class Page < ActiveRecord::Base
    has_many :revisions, class_name: "PageRevision"
    has_one :current_revision, class_name: "PageRevision"

    validates :url, presence: true, uniqueness: true

    attr_writer :revision

    scope :in_project, -> (project) do
      includes(:revisions).where(PageRevision.arel_table.name => { project_id: project.id })
    end

    def revision
      @revision || current_revision
    end

    def build_revision_from_params(page_revision)
      page_revision = page_revision.convert_keys(:underscore).with_indifferent_access
      self.revision = revisions.build message: page_revision[:message], project_id: page_revision[:project_id]

      page_revision[:sections].each do |section_json|
        revision.sections.build section_json.except(:id)
      end
    end

  end
end
