json.array! @materials do |material|
  json.id material.id
  json.parent_id material.parent_id
  json.no material.no
  json.title material.name
  json.subtitle material.en_name
end
