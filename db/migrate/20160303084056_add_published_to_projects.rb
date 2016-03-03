class AddPublishedToProjects < ActiveRecord::Migration
  def change
    add_column :ninetails_projects, :published, :boolean, default: false
  end
end
