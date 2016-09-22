class AddVariantToContentSection < ActiveRecord::Migration[5.0]
  def change
    add_column :ninetails_content_sections, :variant, :string
  end
end
