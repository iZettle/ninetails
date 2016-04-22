json.container do
  json.call container, :id, :name
  json.revision_id container.try(:revision).try(:id)
  json.type container.type.demodulize

  if container.is_a? Ninetails::Page
    json.url container.url

    if container.layout.present?
      json.layout do
        json.partial! "/ninetails/containers/container", container: container.layout
      end
    end
  end

  if container.revision.present?
    json.sections container.revision.sections, partial: "/ninetails/sections/section", as: :section
  else
    json.sections []
  end

  if container.errors.present?
    json.errors container.errors
  end
end
