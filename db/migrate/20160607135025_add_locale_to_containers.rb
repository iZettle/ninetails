class AddLocaleToContainers < ActiveRecord::Migration
  def change
    add_column :ninetails_containers, :locale, :string
  end
end
