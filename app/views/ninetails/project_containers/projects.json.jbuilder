json.projects @project_containers do |project_container|
  json.call project_container.project, :id, :name, :description, :published
end
