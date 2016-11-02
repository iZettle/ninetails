module Ninetails
  class Container < ActiveRecord::Base
    acts_as_paranoid

    has_many :revisions
    has_many :project_containers
    belongs_to :current_revision, class_name: "Revision"

    scope :pages, -> { where type: 'Ninetails::Page' }
    scope :layouts, -> { where type: 'Ninetails::Layout' }

    attr_writer :revision

    validates :locale, presence: true

    def self.find_and_load_revision(params, project = nil)
      if params[:id].to_s =~ /^\d+$/
        selector = where id: params[:id]
      else
        selector = joins(:revisions).merge Ninetails::Revision.where(url: params[:id])
      end

      container = selector.includes(:current_revision).first!
      container.load_revision_directly_or_from_project params[:revision_id], project
      container
    end

    def revision
      @revision || current_revision
    end

    def build_revision_from_params(params)
      params = params.to_h.convert_keys.with_indifferent_access
      self.revision = revisions.build(
        message: params[:message],
        project_id: params[:project_id],
        url: params[:url]
      )

      params[:sections].each do |section_json|
        revision.sections.build section_json.slice(:name, :type, :elements, :variant)
      end
    end

    def set_current_revision(revision)
      update_attributes current_revision: revision
      self.revision = revision
    end

    def load_revision_directly_or_from_project(revision_id, project)
      if revision_id.present?
        self.revision = revisions.find revision_id
      elsif project.present?
        project_container = project_containers.where(project: project, container: self).first
        self.revision = project_container.revision if project_container.present?
      end
    end

  end
end
