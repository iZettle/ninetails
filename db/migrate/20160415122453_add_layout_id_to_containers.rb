class AddLayoutIdToContainers < ActiveRecord::Migration[5.0]
  def change
    add_reference :ninetails_containers, :layout
  end
end
