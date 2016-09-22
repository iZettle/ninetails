class AddPublishedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_projects, :published, :boolean, default: false
  end
end
