class AddDeletedAtToNinetailsContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_containers, :deleted_at, :datetime
    add_index :ninetails_containers, :deleted_at
  end
end
