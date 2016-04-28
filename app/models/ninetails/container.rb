module Ninetails
  class Container < ActiveRecord::Base

    has_many :revisions
    has_many :project_containers
    has_one :current_revision, class_name: "Revision"

    scope :pages, -> { where type: 'Ninetails::Page' }
    scope :layouts, -> { where type: 'Ninetails::Layout' }

    attr_writer :revision

    def self.find_and_load_revision(params, project = nil)
      if params[:id].to_s =~ /^\d+$/
        container = find params[:id]
      else
        container = find_by_url! params[:id]
      end

      container.load_revision_directly_or_from_project params[:revision_id], project
      container
    end

    def revision
      @revision || current_revision
    end

    def build_revision_from_params(params)
      params = params.convert_keys(:underscore).with_indifferent_access
      self.revision = revisions.build message: params[:message], project_id: params[:project_id]

      params[:sections].each do |section_json|
        revision.sections.build section_json.only(:name, :type, :elements)
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
