class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_projects do |t|
      t.string :name
      t.string :description
    end
  end
end
