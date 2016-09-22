module Ninetails
  class ProjectContainer < ActiveRecord::Base

    belongs_to :container
    belongs_to :revision
    belongs_to :project

    validates :project, {
      presence: true
    }

    validates :revision, {
      uniqueness: {
        scope: [:project, :container],
        message: "has already been set for this container in the project"
      }
    }

    validates :container, {
      presence: true,
      uniqueness: {
        scope: :project,
        message: "is already used in this project"
      }
    }

  end
end
