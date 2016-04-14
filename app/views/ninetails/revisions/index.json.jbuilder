json.revisions @container.revisions do |revision|
  json.call revision, :id, :container_id, :created_at, :updated_at, :message
  json.sections revision.sections, partial: "/ninetails/sections/section", as: :section
end
