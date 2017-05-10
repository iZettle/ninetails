class AddReferenceToSections < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_content_sections, :reference, :string
  end
end
