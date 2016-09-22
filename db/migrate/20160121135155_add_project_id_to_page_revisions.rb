class AddProjectIdToPageRevisions < ActiveRecord::Migration[5.0]
  def change
    add_reference :ninetails_page_revisions, :project
  end
end
