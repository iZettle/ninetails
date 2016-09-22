class CreatePageRevisionSections < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_page_revision_sections do |t|
      t.belongs_to :page_revision, index: true
      t.belongs_to :section, index: true
    end
  end
end
