class MoveLocaleAndNameToRevisions < ActiveRecord::Migration[5.0]
  def up
    add_column :ninetails_revisions, :name, :string
    add_column :ninetails_revisions, :locale, :string

    execute %{
      UPDATE ninetails_revisions r
      SET name = c.name,
          locale = c.locale
      FROM ninetails_containers c
      WHERE r.container_id = c.id
    }

    remove_column :ninetails_containers, :name
    remove_column :ninetails_containers, :locale
  end

  def down
    add_column :ninetails_containers, :name, :string
    add_column :ninetails_containers, :locale, :string

    execute %{
      UPDATE ninetails_containers c
      SET name = r.name,
          locale = r.locale
      FROM ninetails_revisions r
      WHERE c.id = r.container_id
    }

    remove_column :ninetails_revisions, :name
    remove_column :ninetails_revisions, :locale
  end
end
