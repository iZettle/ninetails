class AddVariantToContentSection < ActiveRecord::Migration
  def change
    add_column :ninetails_content_sections, :variant, :string
  end
end
