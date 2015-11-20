class AddMessageToPageRevisions < ActiveRecord::Migration
  def change
    add_column :ninetails_page_revisions, :message, :string
  end
end
