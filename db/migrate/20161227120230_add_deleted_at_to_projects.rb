class AddDeletedAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_projects, :deleted_at, :datetime
    add_index :ninetails_projects, :deleted_at
  end
end
