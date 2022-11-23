# 数值统计
json.statistics @statistics

# 近日更新材料
json.recently_materials @recently_materials do |material|
  json.id material.material_id
  json.name material.name
  json.cover mat_img_url(material.cover)
end

# 近日更新项目
json.recently_projects @recently_projects do |project|
  json.id project.case_id
  json.name project.name
  json.cover mat_img_url(project.cover)
end

# 最新新闻
json.latest_news @latest_news do |news|
  json.id news.id
  json.published_at news.published_at&.strftime('%Y-%m-%d %H:%M:%S')
  json.title news.title
  json.subtitle news.subtitle
  json.url news.url
  tags = []
  tags << news.source if news.source.present?
  if news.materials.present?
    news.materials.each do |material|
      tags << material.name
    end
  end
  json.tags tags
end

# 材料分类
json.material_cates @material_cates do |material_cate|
  json.id material_cate[:mat].id
  json.title material_cate[:title]
  json.subtitle material_cate[:subtitle]
  json.cover static_file_url(image_pack_path(material_cate[:cover]))
end

# 项目列表
json.projects @projects do |project|
  json.id project.case_id
  json.name project.home_top_case.project_name
  json.cover mat_img_url(project.cover)
  json.location project.home_top_case.project_location
  json.material_tags project.home_top_case.material_tags
  json.is_th project.home_top_case.is_th
  json.is_th_str project.home_top_case.is_th_str
end

# 供应商分类
json.manufacturer_cates @manufacturer_cates do |manufacturer_cate|
  json.id manufacturer_cate[:id]
  json.name manufacturer_cate[:name]
  json.manufacturers manufacturer_cate[:manufacturers] do |manufacturer|
    json.id manufacturer[:id]
    json.name manufacturer[:name]
    json.logo mat_img_url(manufacturer[:logo])
  end
end
