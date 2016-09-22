class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_pages do |t|
      t.references :current_revision, index: true
      t.string :name
      t.string :url
      t.timestamps null: false
    end
  end
end
