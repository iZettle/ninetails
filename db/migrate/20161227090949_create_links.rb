class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :ninetails_links do |t|
      t.belongs_to :container
      t.belongs_to :linked_container
      t.string :relationship
    end
  end
end
