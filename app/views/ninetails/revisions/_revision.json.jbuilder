if revision.present?
  if container_type.present? && container_type == Ninetails::Page
    json.call revision, :id, :url, :published
  else
    json.call revision, :id
  end
  json.sections revision.sections, partial: "/ninetails/sections/section", as: :section

  if revision.errors.present?
    json.errors revision.errors
  end
else
  json.sections []
end
