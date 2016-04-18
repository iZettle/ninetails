module Ninetails
  class Container < ActiveRecord::Base

    has_many :revisions
    has_many :project_containers
    has_one :current_revision, class_name: "Revision"

    attr_writer :revision

    def revision
      @revision || current_revision
    end

    def build_revision_from_params(params)
      params = params.convert_keys(:underscore).with_indifferent_access
      self.revision = revisions.build message: params[:message], project_id: params[:project_id]

      params[:sections].each do |section_json|
        revision.sections.build section_json.except(:id)
      end
    end

    def set_current_revision(revision)
      update_attributes current_revision: revision
      self.revision = revision
    end

    def load_revision_from_project(project)
      project_container = project_containers.where(project: project, container: self).first
      self.revision = project_container.revision if project_container.present?
    end

  end
end
