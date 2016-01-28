module Ninetails
  class ProjectPage < ActiveRecord::Base

    belongs_to :page
    belongs_to :page_revision
    belongs_to :project

    validates :project, {
      presence: true
    }

    validates :page_revision, {
      uniqueness: {
        scope: :project,
        message: "has already been set for this page in the project"
      }
    }

    validates :page, {
      presence: true,
      uniqueness: {
        scope: :project,
        message: "is already used in this project"
      }
    }

  end
end
