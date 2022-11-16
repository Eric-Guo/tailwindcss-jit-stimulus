json.id @manufacturer.id
json.name @manufacturer.name # 名称
json.logo mat_img_url(@manufacturer.logo) # LOGO
json.location @manufacturer.location # 服务区域
json.website @manufacturer.website # 网址
json.main_materials @manufacturer.main_materials # 主营材料
json.tho_co_str @manufacturer.tho_co_str # 是否与天华合作过
json.offer_sample @manufacturer.offer_sample # 是否愿意提供样品
json.main_material_remark @manufacturer.main_material_remark # 主营业务
# 联系方式
json.contacts @manufacturer.contacts do |contact|
  json.name contact.name
  json.tel contact.tel
end
# 作品展示
json.banners @manufacturer.banners do |banner|
  json.name banner[:name]
  json.url mat_img_url(banner[:url])
end
# 材料
json.materials @materials do |material|
  json.id material.id
  json.name material.name
  json.cover mat_img_url(material.cover)
  json.level_name material.level_name
end
# 样品
json.samples @samples do |sample|
  json.id sample.id
  json.name "#{sample.material.name}（样品）"
  json.cover mat_img_url(sample.pic)
  json.level_name sample.material.level_name
end
# 案例
json.projects @projects do |project|
  json.id project.id
  json.name project.proejct_name
  json.location project.project_location
  json.cover mat_img_url(project.web_cover)
  json.is_th project.is_th
  json.is_th_str project.is_th_str
  json.material_tags project.material_tags
end
# 新闻
json.news @news do |news|
  json.id news.id
  json.title news.title
  json.subtitle news.subtitle
  json.cover mat_img_url(news.cover)
  json.url news.url
  json.published_at news.published_at&.strftime('%Y-%m-%d %H:%M:%S')
  tags = []
  if news.source.present?
    tags << news.source
  end
  news.materials.each do |material|
    tags << material.name
  end
  json.tags = tags
end
# 企业宣传册
json.brochures @manufacturer.brochure_files do |brochure|
  json.name brochure[:name]
  json.type brochure[:tag_name]
  json.url mat_img_url[:url]
end
