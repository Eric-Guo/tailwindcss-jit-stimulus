json.id @material.id
json.no @material.no
json.name @material.name
json.en_name @material.en_name
json.level @material.level
json.parent_id @material.parent_id
json.grandpa_id @material.grandpa_id
json.cover get_first_url(@material.cover)

# 项目
projects = @material.cases.limit(4)
json.projects projects do |project|
  json.id project.id
  json.name project.project_name # 名称
  json.location project.project_location # 地区
  json.cover mat_img_url(project.web_cover) # 封面
  json.material_tags project.material_tags # 材料标签
  json.is_th project.is_th # 是否内部项目
  json.is_th_str project.is_th_str # 是否内部项目描述
end

if @material.level == 2
  # 轮播图
  if @material.picture_arr.present?
    json.banners @material.picture_arr do |url|
      json.url mat_img_url(url)
    end
  end
  json.intro @material.remark # 材料简介
  json.technology @material.material_info&.technology_str # 处理工艺
  json.price_range @material.material_info&.price_range # 价格区间
  json.advantage @material.material_info&.advantage # 优点
  json.shortcoming @material.material_info&.shortcoming # 缺点
  json.scope @material.material_info&.scope # 适用范围
  json.common_parameters @material.material_info&.common_parameters # 常用参数
  json.installation_points @material.material_info&.points # 安装施工要点
  json.design_considerations @material.material_info&.design_considerations # 设计注意事项

  # 构造做法
  json.constructions @material.construction do |construction|
    json.url mat_img_url(construction[:url])
  end

  # 相关文件
  if @material.material_info&.related_files.present?
    json.related_files @material.material_info.related_files do |file|
      json.name file[:name]
      json.url mat_img_url(file[:url])
      json.extname File.extname(file[:url]).downcase
    end
  end

  # 细节品控
  if @material.parent_material&.qc_details.present?
    json.qc_details @material.parent_material.qc_details do |qc_detail|
      json.title qc_detail.title
      json.cover mat_img_url(qc_detail.cover)
      json.url mat_img_url(qc_detail.path)
    end
  end

  # 施工构造
  if @material.parent_material&.qc_constructions.present?
    json.qc_constructions @material.parent_material.qc_constructions do |qc_construction|
      json.title qc_construction.title
      json.cover mat_img_url(qc_construction.cover)
      json.url mat_img_url(qc_construction.path)
    end
  end

  # 新闻
  news = @material.parent_material.news.limit(4)
  json.news news do |item|
    json.id item.id
    json.title item.title
    json.subtitle item.subtitle
    json.cover mat_img_url(item.cover)
    tags = []
    if item.source.present?
      tags << item.source
    end
    if item.materials.present?
      item.materials.each { |material| tags << material.name }
    end
    json.tags tags
    json.published_at item.published_at&.strftime('%Y-%m-%d')
    json.url item.url
  end
end

if @material.level == 3
  json.color_system @material.color # 色系
  json.origin_place @material.material_product&.origin # 产地
  json.price_range @material.material_product&.price_range # 价格区间
  json.is_commonly_used @material.material_product&.is_commonly_used # 是否常用
  json.surface_effect @material.surface_effect_descriptions # 表面效果
  json.customizable_effect @material.customizable_effect # 可定制效果
  # 实际应用
  if @material.material_product&.practical_applications_json.present?
    json.practical_applications @material.material_product.practical_applications_json do |practical_application|
      json.name practical_application[:name]
      json.url mat_img_url(practical_application[:url])
    end
  else
    json.practical_applications [{ name: '无', url: static_file_url(image_pack_path('materials-applications-default.jpg')) }]
  end
  # 样品
  json.samples @material.samples do |sample|
    json.id sample.id # 样品ID
    json.no sample.no # 样品编号
    json.description sample.material_text # 样品描述
    json.spec_model sample.spec_model # 样品规格
    json.surface_effect sample.surface_effect_descriptions # 表面工艺
    json.position sample.position # 存放位置
  end
  # 源文件
  if @material.material_product&.files.present?
    json.files @material.material_product.files do |file|
      json.name file[:name]
      json.url mat_img_url(file[:url])
    end
  end
  # 材质贴图
  if @material.material_product&.texture.present?
    json.textures @material.material_product.texture do |texture|
      json.url mat_img_url(texture[:url])
    end
  end
  # 供应商信息
  if @material.manufacturers.present?
    json.manufacturers @material.manufacturers do |manufacturer|
      json.id manufacturer.id # ID
      json.name manufacturer.name # 名称
      json.logo mat_img_url(manufacturer.logo) # LOGO
      json.location manufacturer.location # 服务区域
      json.contact_information manufacturer.contact_information # 联系方式
      json.offer_sample manufacturer.offer_sample # 是否愿意提供样品
    end
  end
end
