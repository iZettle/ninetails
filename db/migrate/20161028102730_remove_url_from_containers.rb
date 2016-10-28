class RemoveUrlFromContainers < ActiveRecord::Migration[5.0]
  def change
    remove_column :ninetails_containers, :url, :string
  end
end
