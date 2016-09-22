class RenameTablesToRemovePages < ActiveRecord::Migration[5.0]
  def up
    remove_index :ninetails_page_revision_sections, name: :index_ninetails_page_revision_sections_on_page_revision_id
    remove_index :ninetails_page_revision_sections, name: :index_ninetails_page_revision_sections_on_section_id
    remove_index :ninetails_pages, name: :index_ninetails_pages_on_current_revision_id

    add_index :ninetails_revision_sections, [:revision_id], name: "ninetails_revision_sections_on_revision_id", using: :btree
    add_index :ninetails_revision_sections, [:section_id], name: "ninetails_revision_sections_on_section_id", using: :btree
    add_index :ninetails_containers, [:current_revision_id], name: "ninetails_containers_on_current_revision_id", using: :btree
  end

  def change
    rename_table :ninetails_pages, :ninetails_containers
    rename_table :ninetails_project_pages, :ninetails_project_containers
    rename_table :ninetails_page_revisions, :ninetails_revisions
    rename_table :ninetails_page_sections, :ninetails_content_sections
    rename_table :ninetails_page_revision_sections, :ninetails_revision_sections

    rename_column :ninetails_revisions, :page_id, :container_id
    rename_column :ninetails_project_containers, :page_id, :container_id
    rename_column :ninetails_project_containers, :page_revision_id, :revision_id
    rename_column :ninetails_revision_sections, :page_revision_id, :revision_id
  end
end
