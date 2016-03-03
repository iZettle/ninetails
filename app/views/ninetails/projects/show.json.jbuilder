json.project do
  json.call @project, :id, :name, :description, :published

  if @project.errors.present?
    json.errors @project.errors
  end
end
