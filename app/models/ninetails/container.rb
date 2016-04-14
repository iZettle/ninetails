module Ninetails
  class Container < ActiveRecord::Base
    has_many :revisions
    has_one :current_revision, class_name: "Revision"

    validates :url, presence: true, uniqueness: true

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

  end
end
