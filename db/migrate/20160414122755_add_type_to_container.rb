class AddTypeToContainer < ActiveRecord::Migration
  def change
    add_column :ninetails_containers, :type, :integer, default: 0
  end
end
