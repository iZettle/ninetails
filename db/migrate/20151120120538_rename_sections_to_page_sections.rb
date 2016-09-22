class RenameSectionsToPageSections < ActiveRecord::Migration[5.0]
  def change
    rename_table :ninetails_sections, :ninetails_page_sections
  end
end
