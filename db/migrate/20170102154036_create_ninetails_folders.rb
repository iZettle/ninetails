class CreateNinetailsFolders < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_folders do |t|
      t.string :name
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
