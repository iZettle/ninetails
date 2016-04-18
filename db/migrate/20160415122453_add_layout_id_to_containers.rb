class AddLayoutIdToContainers < ActiveRecord::Migration
  def change
    add_reference :ninetails_containers, :layout
  end
end
