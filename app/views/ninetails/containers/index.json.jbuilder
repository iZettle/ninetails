json.containers @containers do |container|
  json.call container, :id, :name

  if container.is_a? Ninetails::Page
    json.url container.url
  end

  json.type container.type.demodulize
end
