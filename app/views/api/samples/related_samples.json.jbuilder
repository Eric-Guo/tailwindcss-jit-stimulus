json.total @total
json.list @list do |sample|
  json.id sample.id
  json.name sample.name
  json.no sample.no
  json.cover mat_img_url(sample.pic)
  json.surface_effect sample.surface_effect_descriptions
  json.color_system sample.color_str
  if sample.manufacturer.present?
    json.manufacturer do
      json.id sample.manufacturer.id
      json.name sample.manufacturer.name
      json.logo mat_img_url(sample.manufacturer.logo)
    end
  end
end
