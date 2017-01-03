class MoveEverythingToRevisions < ActiveRecord::Migration[5.0]
  def up
    add_column :ninetails_revisions, :name, :string
    add_column :ninetails_revisions, :locale, :string
    add_column :ninetails_revisions, :layout_id, :integer

    execute %{
      UPDATE ninetails_revisions r
      SET name = c.name,
          locale = c.locale,
          layout_id = c.layout_id
      FROM ninetails_containers c
      WHERE r.container_id = c.id
    }

    remove_column :ninetails_containers, :name
    remove_column :ninetails_containers, :locale
    remove_column :ninetails_containers, :layout_id
  end

  def down
    add_column :ninetails_containers, :name, :string
    add_column :ninetails_containers, :locale, :string
    add_column :ninetails_containers, :layout_id, :integer

    execute %{
      UPDATE ninetails_containers c
      SET name = r.name,
          locale = r.locale,
          layout_id = r.layout_id
      FROM ninetails_revisions r
      WHERE c.id = r.container_id
    }

    remove_column :ninetails_revisions, :name
    remove_column :ninetails_revisions, :locale
    remove_column :ninetails_revisions, :layout_id
  end
end
