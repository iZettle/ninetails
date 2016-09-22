class AddLocaleToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_containers, :locale, :string
  end
end
