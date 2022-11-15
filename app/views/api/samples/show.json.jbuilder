json.id @sample.id
json.name @sample.name
json.no @sample.no
json.cover mat_img_url(@sample.pic)
json.description @sample.material_text
json.price_range @sample.price_range
# 材料信息
json.material do
  json.id @sample.material.id
  json.name @sample.material.name
  json.no @sample.material.no
end
json.color_system @sample.color_str # 色系
json.color_code @sample.color_code # 色号
json.model @sample.model # 原厂型号
json.spec_model @sample.spec_model # 产品规格
json.visual @sample.visual # 效果描述
json.surface_effect @sample.surface_effect_descriptions # 表面效果
json.position @sample.position # 存储位置
if @sample.sample_position_picture.present?
  json.position_picture mat_img_url(@sample.sample_position_picture.path)
end
# 供应商信息
if @sample.manufacturer.present?
  json.manufacturer do
    json.id @sample.manufacturer.id
    json.name @sample.manufacturer.name
    json.logo mat_img_url(@sample.manufacturer.logo)
    json.contact @sample.manufacturer.contact # 联系人
    json.email @sample.manufacturer.email # 邮箱
    json.location @sample.manufacturer.location # 地址
    json.company_tel @sample.manufacturer.company_tel # 联系电话
    json.offer_sample @sample.manufacturer.offer_sample # 是否愿意送样
  end
end
# 附件
json.enclosures @sample.sample_enclosures do |enclosure|
  json.name enclosure.name
  json.url mat_img_url(enclosure.path)
end
