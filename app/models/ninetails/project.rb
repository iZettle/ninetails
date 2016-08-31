module Ninetails
  class Project < ActiveRecord::Base

    has_many :project_containers
    has_many :containers, through: :project_containers

    delegate :pages, :layouts, to: :containers

    validates :name, presence: true

    def publish!
      project_containers.each do |project_container|
        project_container.container.set_current_revision project_container.revision
      end

      update_attributes published: true
    end

  end
end
