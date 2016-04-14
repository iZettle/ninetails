json.container do
  json.call container, :id, :name, :url
  json.revision_id container.try(:revision).try(:id)

  if container.revision.present?
    json.sections container.revision.sections, partial: "/ninetails/sections/section", as: :section
  else
    json.sections []
  end

  if container.errors.present?
    json.errors container.errors
  end
end
