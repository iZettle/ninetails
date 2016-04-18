class MakeContentSectionsElementsDefaultToBlankObject < ActiveRecord::Migration
  def change
    change_column :ninetails_content_sections, :elements, :json, default: {}
  end
end
