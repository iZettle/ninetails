class CreateProjectPages < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_project_pages do |t|
      t.belongs_to :project
      t.belongs_to :page
      t.belongs_to :page_revision
    end
  end
end
