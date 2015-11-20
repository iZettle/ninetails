class CreateSections < ActiveRecord::Migration
  def change
    create_table :ninetails_sections do |t|
      t.string :name
      t.string :type
      t.json :elements
      t.json :tags
      t.timestamps null: false
    end
  end
end
