json.containers @containers do |container|
  json.call container, :id, :name, :locale
  json.type container.type.demodulize
end
