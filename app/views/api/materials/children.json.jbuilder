json.array! @list do |material|
  json.id material.id
  json.no material.no
  json.name material.name
  json.en_name material.en_name
  json.level material.level
  json.parent_id material.parent_id
  json.grandpa_id material.grandpa_id
  json.color_system_ids material&.material_product&.color_systems&.pluck(:id)
  json.cover get_first_url(material.cover)
end
