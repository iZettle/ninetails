class RenameSectionTagsToSettings < ActiveRecord::Migration[5.0]
  def change
    remove_column :ninetails_content_sections, :tags, :json
    add_column :ninetails_content_sections, :settings, :json, default: {}
  end
end
