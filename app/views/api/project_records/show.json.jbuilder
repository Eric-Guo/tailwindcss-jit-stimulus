json.id @project.id
json.name @project.project_name #项目名称
json.no @project.no # 项目编号
json.detail_url @project.detail_url
json.finish_year @project.finish_year # 完工年份
json.location @project.project_location # 项目地区
json.project_type @project.project_type # 项目类型
json.design_unit @project.design_unit # 设计单位
json.build_unit @project.build_unit # 建筑单位
json.business_type @project.business_type # 业务类型
# 轮播图
json.banners @project.live_photos do |photo|
  json.cover photo.show_cover
  json.url photo.show_path
end
# 材料
json.materials @project.case_materials.includes(:material, :manufacturer) do |case_material|
  json.id case_material.material.id
  json.name case_material.material.name
  json.cover get_first_url(case_material.material.cover)
  json.position case_material.position
  json.color case_material.material_color
  json.surface_effect case_material.material.surface_effect_descriptions # 表面效果
  json.effect_description case_material.effect_description # 效果描述
  json.treatment_process case_material.treatment_process # 处理工艺
  json.spec_model case_material.spec_model # 规格型号
   # 供应商
  if case_material.manufacturer.present?
    json.manufacturer do
      json.id case_material.manufacturer.id
      json.name case_material.manufacturer.name
      json.logo mat_img_url(case_material.manufacturer.logo)
    end
  end
  json.remark case_material.remark # 其他属性
end
# 样品
json.samples @project.samples.includes(:material) do |sample|
  json.id sample.id
  json.cover mat_img_url(sample.pic)
  json.name "#{sample.material.name}（样品）"
  json.color sample.color_str # 色系
  json.surface_effect sample.surface_effect # 表面效果
  json.spec_model sample.spec_model # 规格
end
# 立面控制手册
if @project.facade.present?
  json.facades @project.facade do |facade|
    json.name facade[:name]
    json.url facade[:url]
    json.extname File.extname(facade[:url]).downcase
  end
end
# 相关文件
if @project.related_files.present?
  json.related_files @project.related_files do |file|
    json.name file[:name]
    json.url file[:url]
    json.extname File.extname(file[:url]).downcase
  end
end
