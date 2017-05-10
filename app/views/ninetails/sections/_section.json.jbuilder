json.call section, :id, :name, :type, :located_in, :location_name, :variant, :elements, :reference

if section.settings.present?
  json.call section, :settings
else
  json.settings section.section.generate_settings
end

json.data section.section.generate_data
