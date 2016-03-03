module Ninetails
  class Project < ActiveRecord::Base

    has_many :project_pages
    has_many :pages, through: :project_pages

    validates :name, presence: true

    def publish!
      project_pages.each do |project_page|
        project_page.page.set_current_revision project_page.page_revision
      end

      update_attributes published: true
    end

  end
end
