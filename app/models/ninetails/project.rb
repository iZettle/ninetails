module Ninetails
  class Project < ActiveRecord::Base

    has_many :project_pages
    has_many :pages, through: :project_pages

    validates :name, presence: true

  end
end
