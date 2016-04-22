module Ninetails
  class RevisionSection < ActiveRecord::Base
    belongs_to :revision
    belongs_to :section, class_name: "ContentSection"
  end
end
