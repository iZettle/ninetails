json.folder do
  json.call @folder, :id, :name, :created_at, :updated_at, :deleted_at

  if @folder.errors.present?
    json.errors @folder.errors
  end
end
