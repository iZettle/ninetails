class AddUrlAndPublishedToRevision < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_revisions, :url, :string
    add_column :ninetails_revisions, :published, :boolean, default: false
  end
end
