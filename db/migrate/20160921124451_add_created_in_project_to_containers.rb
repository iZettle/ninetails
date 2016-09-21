class AddCreatedInProjectToContainers < ActiveRecord::Migration[5.0]
  def change
    add_reference :ninetails_containers, :created_in_project
  end
end
