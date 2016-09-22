class AddTypeToContainer < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_containers, :type, :string, default: "Ninetails::Page"
  end
end
