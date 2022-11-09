json.total @total
json.list @list do |item|
  if item.sample_id.present?
    json.type 'sample'
    json.id item.sample.id
    json.name "#{item.material_name}（样品）"
    json.cover item.sample_cover.present? ? mat_img_url(item.sample_cover, "") : get_first_url(item.material_cover)
  else
    json.type 'material'
    json.id item.material_id
    json.name item.material_name
    json.cover get_first_url(item.material_cover)
  end
  json.level_name item.level_name
end
