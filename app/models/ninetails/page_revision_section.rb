module Ninetails
  class PageRevisionSection < ActiveRecord::Base
    belongs_to :page_revision
    belongs_to :section, class_name: "PageSection"
  end
end
