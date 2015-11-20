class RenameSectionsToPageSections < ActiveRecord::Migration
  def change
    rename_table :ninetails_sections, :ninetails_page_sections
  end
end
