class AddMessageToPageRevisions < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_page_revisions, :message, :string
  end
end
