class AddFolderToRevisions < ActiveRecord::Migration[5.0]
  def change
    add_reference :ninetails_revisions, :folder
  end
end
