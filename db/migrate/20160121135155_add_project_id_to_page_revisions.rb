class AddProjectIdToPageRevisions < ActiveRecord::Migration
  def change
    add_reference :ninetails_page_revisions, :project
  end
end
