class RenameSectionTagsToSettings < ActiveRecord::Migration[5.0]
  def change
    rename_column :ninetails_content_sections, :tags, :settings
  end
end
