json.project do
  json.call @project, :id, :name, :description

  if @project.errors.present?
    json.errors @project.errors
  end
end
