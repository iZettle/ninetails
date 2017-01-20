json.project do
  json.call @project, :id, :name, :description, :published, :created_at, :updated_at

  if @project.errors.present?
    json.errors @project.errors
  end
end
