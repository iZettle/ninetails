module Ninetails
  class Page < ActiveRecord::Base
    has_many :revisions, class_name: "PageRevision"
    has_one :current_revision, class_name: "PageRevision"

    validates :url, presence: true, uniqueness: true

    attr_writer :revision

    def revision
      @revision || current_revision
    end

    def to_builder
      Jbuilder.new do |json|
        json.page do
          json.call(self, :id, :name, :url)

          if revision.present?
            json.revision_id revision.id
            json.sections sections_to_builder
          end

          if errors.present?
            json.errors errors
          end
        end
      end
    end

    def sections_to_builder
      revision.sections.collect do |section|
        section.to_builder.attributes!
      end
    end

    def build_revision_from_params(page_revision)
      self.revision = revisions.build message: page_revision[:message]

      page_revision[:sections].each do |section_json|
        revision.sections.build section_json.except(:id)
      end
    end

  end
end
