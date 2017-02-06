class AddTimestampsToEverything < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_project_containers, :created_at, :datetime
    add_column :ninetails_project_containers, :updated_at, :datetime

    add_column :ninetails_projects, :created_at, :datetime
    add_column :ninetails_projects, :updated_at, :datetime

    add_column :ninetails_revision_sections, :created_at, :datetime
    add_column :ninetails_revision_sections, :updated_at, :datetime
  end
end
