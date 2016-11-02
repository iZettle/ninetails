json.container do
  json.call container, :id, :name, :locale
  json.type container.type.demodulize

  if container.try(:layout).present?
    json.layout do
      json.partial! "/ninetails/containers/container", container: container.layout
    end
  end

  json.current_revision do
    json.partial! "/ninetails/revisions/revision", revision: container.current_revision, container_type: container.class
  end

  if container.revision != container.current_revision
    json.revision do
      json.partial! "/ninetails/revisions/revision", revision: container.revision, container_type: container.class
    end
  end

  if container.errors.present?
    json.errors container.errors
  end
end
