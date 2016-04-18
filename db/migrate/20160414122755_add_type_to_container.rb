class AddTypeToContainer < ActiveRecord::Migration
  def change
    add_column :ninetails_containers, :type, :string, default: "Ninetails::Page"
  end
end
