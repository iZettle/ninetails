json.containers @containers do |container|
  if container.is_a? Ninetails::ProjectContainer
    json.call container.container, :id
  else
    json.call container, :id
  end

  json.type container.type.demodulize

  if container.current_revision.present?
    json.current_revision do
      json.call container.current_revision, :url, :published, :name, :url, :locale
    end
  end

  if container.revision.present?
    json.revision do
      json.call container.revision, :url, :published, :name, :url, :locale
    end
  end
end
