if revision.present?
  json.call revision, :id, :name, :locale, :folder_id

  if container_type.present? && container_type == Ninetails::Page
    json.call revision, :url, :published
  end

  if revision.folder.present?
    json.partial! "/ninetails/folders/folder", folder: revision.folder
  end

  # json.sections revision.sections, partial: "/ninetails/sections/section", as: :section
  json.sections revision.sections do |section|
    json.call section, :id, :name, :type, :located_in, :location_name, :variant, :elements

    if section.settings.present?
      json.call section, :settings
    else
      json.settings section.section.generate_settings
    end

    json.data section.section.generate_data
  end

  if revision.errors.present?
    json.errors revision.errors
  end
else
  json.sections []
end
