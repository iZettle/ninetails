json.project_containers @project_containers do |project_container|
  json.call project_container, :id, :project_id, :container_id, :revision_id
end
