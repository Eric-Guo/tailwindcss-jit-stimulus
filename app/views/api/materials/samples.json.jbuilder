json.array! @material.samples do |sample|
  json.id sample.id
  json.no sample.no # 编号
  json.name sample.name # 名称
  json.cover mat_img_url(sample.pic) # 封面
  json.surface_effect sample.surface_effect_descriptions # 表面效果
  json.color_system sample.color_str # 色系
  if sample.manufacturer.present?
    json.manufacturer do
      json.id sample.manufacturer.id
      json.name sample.manufacturer.name
      json.logo mat_img_url(sample.manufacturer.logo)
    end
  end
end
