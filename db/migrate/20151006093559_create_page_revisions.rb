class CreatePageRevisions < ActiveRecord::Migration
  def change
    create_table :ninetails_page_revisions do |t|
      t.belongs_to :page
      t.timestamps null: false
    end
  end
end
