class MakeContentSectionsElementsDefaultToBlankObject < ActiveRecord::Migration[5.0]
  def change
    change_column :ninetails_content_sections, :elements, :json, default: {}
  end
end
