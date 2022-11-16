json.total @total
json.list @list do |manufacturer|
  json.id manufacturer.id
  json.name manufacturer.name # 名称
  json.logo mat_img_url(manufacturer.logo) # LOGO
  json.location manufacturer.location # 服务区域
  json.company_tel manufacturer.company_tel # 联系方式
  json.offer_sample manufacturer.offer_sample # 是否愿意提供样品
end
