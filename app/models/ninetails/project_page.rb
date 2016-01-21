module Ninetails
  class ProjectPage < ActiveRecord::Base

    belongs_to :page
    belongs_to :page_revision
    belongs_to :project

    validates :page_revision, uniqueness: { scope: :project, message: "has already been set for this page in the project" }
    validates :page, uniqueness: { scope: :project, message: "is already used in this project" }

  end
end
