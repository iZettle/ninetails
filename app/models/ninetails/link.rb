module Ninetails
  class Link < ActiveRecord::Base
    belongs_to :container
    belongs_to :linked_container, class_name: "Container"
  end
end
