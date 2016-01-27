json.page do
  json.call page, :id, :name, :url
  json.revision_id page.try(:revision).try(:id)

  if page.revision.present?
    json.sections page.revision.sections, partial: "/ninetails/sections/section", as: :section
  else
    json.sections []
  end

  if page.errors.present?
    json.errors page.errors
  end
end
