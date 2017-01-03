if revision.present?
  json.call revision, :id, :name, :locale, :folder_id

  if container_type.present? && container_type == Ninetails::Page
    json.call revision, :url, :published
  end

  json.sections revision.sections, partial: "/ninetails/sections/section", as: :section

  if revision.errors.present?
    json.errors revision.errors
  end
else
  json.sections []
end
