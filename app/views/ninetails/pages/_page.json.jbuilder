json.page do
  json.call page, :id, :name, :url

  if page.revision.present?
    json.revision_id page.revision.id

    json.sections page.revision.sections, partial: "/ninetails/sections/section", as: :section
  end

  if page.errors.present?
    json.errors page.errors
  end
end
