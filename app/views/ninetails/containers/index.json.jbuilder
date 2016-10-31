if @project_containers.present?
  json.containers @project_containers do |project_container|
    json.call project_container.container, :id, :name, :locale
    json.call project_container.revision, :url, :published
    json.type project_container.container.type.demodulize
  end
else
  json.containers @containers do |container|
    json.call container, :id, :name, :locale
    
    if container.current_revision.present?
      json.call container.current_revision, :url, :published
    end

    json.type container.type.demodulize
  end
end
