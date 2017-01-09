json.folder do
  json.call folder, :id, :name, :created_at, :updated_at, :deleted_at

  json.revisions folder.revisions.live, :id, :container_id, :url, :locale, :published

  if folder.errors.present?
    json.errors folder.errors
  end
end
