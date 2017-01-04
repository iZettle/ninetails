json.container do
  json.call container, :id
  json.type container.type.demodulize

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
