class AddLocationToSections < ActiveRecord::Migration
  def change
    remove_column :ninetails_content_sections, :tags, :json
    add_column :ninetails_content_sections, :located_in, :string
  end
end
