class RemoveUrlFromContainers < ActiveRecord::Migration[5.0]
  def up
    Ninetails::Page.with_deleted.all.each do |page|
      page.revisions.each do |revision|
        revision.update_attributes url: page.url unless revision.url.present?
      end
    end

    remove_column :ninetails_containers, :url
  end

  def down
    add_column :ninetails_containers, :url, :string
  end
end
