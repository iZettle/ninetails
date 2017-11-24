json.container do
  json.call container, :id
  json.type container.type.demodulize
  json.layout_id container.layout_id

  if container.try(:layout).present?
    json.layout do
      json.partial! "/ninetails/containers/container", container: container.layout
    end
  end

  if container.try(:current_revision).present?
    json.current_revision do
      json.partial! "/ninetails/revisions/revision", revision: container.current_revision, container_type: container.class
    end
  else
    json.current_revision({})
  end

  if container.try(:revision).present?
    json.revision do
      json.partial! "/ninetails/revisions/revision", revision: container.revision, container_type: container.class
    end
  else
    json.revision({})
  end

  if container.errors.present?
    json.errors container.errors
  end
end
