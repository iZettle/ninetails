module Ninetails
  class Folder < ActiveRecord::Base
    acts_as_paranoid

    has_many :revisions

    validates :name, uniqueness: true, presence: true

  end
end
