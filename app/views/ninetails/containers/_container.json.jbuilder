json.container do
  json.call container, :id, :name, :locale
  json.revision_id container.try(:revision).try(:id)
  json.type container.type.demodulize

  if container.try(:layout).present?
    json.layout do
      json.partial! "/ninetails/containers/container", container: container.layout
    end
  end

  if container.revision.present?
    json.published container.revision.published
    json.sections container.revision.sections, partial: "/ninetails/sections/section", as: :section
  else
    json.published false
    json.sections []
  end

  if container.errors.present?
    json.errors container.errors
  end
end
